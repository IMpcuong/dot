0. Ansible:

- Basic command lines:

```bash
ansible --version
ansible-config dump | grep -E "modules?" | head -n1
echo $(ansible-doc --list | wc -l) >> modules # Or: `ansible-doc -l | wc -l > /root/modules`
ansible-doc --snippet setup # Read the snippet (-s) document about given task's name.
ansible-doc --snippet copy

ansible servers -i /root/hosts -m ping # NOTE: Only working with .ini config file's format
# Exp:
# controlplane $ cat hosts
# [servers]
# controlplane
# node01

# Fix done:
# servers:
#   hosts:
#     controlplane:
#     node01:

# NOTE: `setup` was a builtin module/plugin from the Ansible ecosystem (like: `ping`, `shell`, etc),
# that can be used directly to retrieve configuration from an custom inventory.
ansible servers -i /root/hosts -m setup > version
```

- Hosts/servers declaration using `.ini` or `.yaml` (`.yml`) extension:

```ini
[atlanta]
host1
host2

[atlanta:vars]
ntp_server=ntp.atlanta.example.com
proxy=proxy.atlanta.example.com
```

```yml
atlanta:
  hosts:
    host1:
    host2:
  vars:
    ntp_server: ntp.atlanta.example.com
    proxy: proxy.atlanta.example.com
```

- Propagate any specific command(s) to multiple hosts:

```bash
# Pattern: `ansible <pattern> -m <module_name> -a "<module options>"`
# Link: https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html#intro-patterns
#
# `-a MODULE_ARGS, --args MODULE_ARGS`
ansible servers -i /root/hosts.yml -m shell -a "uptime"
ansible servers -i /root/hosts.yml -m shell -a "uname -s"
ansible servers -i /root/hosts.yml -m shell -a "date" > date

# NOTE: `ansible-doc -s setup` --> setup's arguments := {setup's yaml properties := [fact_path, filter, gather_subnet, gather_timeout]}.
ansible servers -i hosts -m setup | grep -iE "^.*"distribution".*"
ansible servers -i hosts -m setup -a "filter=ansible_distribution" > version

ansible servers -i hosts -m setup | grep -iE "^.*"date".*"
ansible servers -i hosts -m setup -a "filter=ansible_date_time" > date

cp ./{hosts,configfile.cfg} /opt/deployment
cp ./{hosts{1,2},configfile.cfg} /opt/deployment # Braces expansion.

sed -i -E "s/0{6}/1{6}/g" configfile.cfg # Transform: `000000 -> 1{6}`
sed -i -E "s/0{6}/111111/g" configfile.cfg # Guess: only detect the presented pattern, not apply with the changes itself.

# Create files/dirs:
ansible servers -i hosts -m file -a "path=/opt/deployment state=directory" # `-vvv`: for debugging mode.
# Copy file to destination directory:
ansible servers -i hosts -m copy -a "src=/root/configfile.cfg dest=/opt/deployment"
# Update content from a specific line (if present in file):
ansible servers -i hosts -m lineinfile -a "path=/opt/deployment/configfile.cfg regexp='^var1' line='var1=11111'"
ansible servers -i hosts -m lineinfile -a "path=/opt/deployment/configfile.cfg regexp='^.*1{6}' line='dude'"
```

```out
controlplane $ cat .wget-hsts
# HSTS 1.0 Known Hosts database for GNU Wget.
# Edit at your own risk.
# <hostname>    <port>  <incl. subdomains>      <created>       <max-age>
github.com
```

- NOTE: A curated list of some simple playbook examples:

```out
# My method:

controlplane $ ansible-lint deploy.yml
controlplane $ cat deploy.yml
---

- name: Push the gun-zipped file tar.gz over to all servers.
  hosts: servers
  remote_user: root

  tasks:
    - name: Push file deploy.tar.gz
      ansible.builtin.copy:
        src: /root/deploy.tar.gz
        dest: /opt

controlplane $ ansible-playbook -i hosts deploy.yml -f 10 -v
# `-f N` := forks N times.
# `-v` := verbose output mode.
```

```out
# Author's method:

controlplane $ sha1sum /root/deploy.tar.gz
c6cd21b75a4b300b9228498c78afc6e7a831839e  /root/deploy.tar.gz

controlplane $ cat deploy.yml
---

- name: Start of Deployer playbook
  hosts: servers
  vars:
  gather_facts: True
  become: False

  tasks:
    - name: Copy deploy.tar.gz over at {{ ansible_date_time.iso8601_basic_short }}
      copy:
        src: /root/deploy.tar.gz
        dest: /opt/deploy.tar.gz
        checksum: c6cd21b75a4b300b9228498c78afc6e7a831839e

controlplane $ ansible servers -i /root/hosts -m shell -a 'ls -l /opt/deploy.tar.gz'
```

```bash
# NOTE: A complete example:
# Always quote template expression brackets when they start a value. For instance:
#    with_items:
#      - {{ foo }}
#
# Should be written as:
#    with_items:
#      - "{{ foo }}"
```

```yml
# Not working properly yet!
---
- name: Deployment zipped file playbook.
  hosts: servers
  vars:
    file_name: /deploy.tar.gz
    file_path: "/root/{{ file_name }}"
  gather_facts: True
  become: False

  tasks:
    - name: Getting the SHA-1 checksum.
      # `ansible.builtin.shell` != `shell` (`shell`: execute existed binary libraries on the host machine.)
      ansible.builtin.shell: |
        /usr/bin/sha1sum "{{ file_path }}" | cut -d ' ' -f1
      register: hash_val

    - name: Binding fact to Ansible's var.
      ansible.builtin.set_fact:
        hash_var: "{{ hash_val.stdout }}"

    - name: Pushing to all hosts from "{{ file_path | b64encode }}" at "{{ ansible_date_time.date }}"
      ansible.builtin.copy:
        src: "{{ file_path }}"
        dest: "/opt/{{ file_name }}"
        checksum: "{{ hash_val }}"
```

````yml
# .ini configuration hosts file:
# ```ini
# [servers]
# controlplane
# node01
# ```

# Working perfectly fine!
---
- name: Test retrieve checksum from file
  hosts: servers
  vars:
    file_name: "deploy.tar.gz"
    app_path: "/opt/app"
  gather_facts: True
  become: False

  tasks:
    - name: Testing task.
      shell: |
        /usr/bin/sha1sum "{{ file_name }}" | cut -d ' ' -f1
      register: test

    - name: Binding variables.
      set_fact:
        hash_var: "{{ test.stdout }}"

    - name: Publishing gun-zipped file at "{{ ansible_date_time.date | b64encode }}"
      copy:
        src: "/root/{{ file_name }}"
        dest: "/opt/{{ file_name }}"
        # FIX: Cannot use `{{ test }}`  here because of the stdout in Ansible (Python) was too large!
        checksum: "{{ hash_var }}"

    - name: Create directory to store unarchive's files.
      file:
        path: "{{ app_path }}"
        state: directory

    - name: Unarchive using builtin module.
      unarchive:
        src: "/opt/{{ file_name }}"
        dest: "{{ app_path }}"

    - name: Make installer script becoming executable.
      file:
        path: "{{ app_path }}/deploy/deployer.sh"
        mode: 0755

    - name: Running installer script.
      shell: "{{ app_path }}/deploy/deployer.sh"
      register: installer_stdout

    - name: Debug and show installer_stdout.
      debug:
        var: installer_stdout

    - name: Unpacked file /opt/"{{ file_name }}"
      shell: |
        tar xvzf "/opt/{{ file_name }}" && \
          find /opt -type f -iname "*.sh"
        if [[ $? == 0 ]]; then sh deployer.sh; fi
````

```bash
# Testing result:
ansible servers -i hosts -m shell -a "ls -lR /opt/app; cat /opt/app//deploy/deployer.sh"
```

- Shared variable(s) that can be used in several server(s):

```yml
# Shared variables between several hosts.
---
- hosts: master01
  tasks:
    - name: Print the value
      shell: |
        echo "hi"
      register: some_variable_name

    - name: Set fact
      set_fact:
        my_var: "{{ some_variable_name.stdout }}"

- hosts: kube-minions
  tasks:
    - name: Print the variable
      shell: |
        echo "{{ hostvars['master01'].my_var }}"
```

```out
"cmd": [
  "/usr/bin/tar",
  "--extract",
  "-C",
  "/opt/app",
  "-z",
  "-f",
  "/root/.ansible/tmp/ansible-tmp-1672629865.7619288-102645114785870/source"
],
```

```yml
# NOTE: Truly final worthy form.
---
- name: Test deployment archive file.
  hosts: servers
  vars:
    - host_file: "hosts"
    - file_name: "deploy.tar.gz"
    - src_dir: "/root"
    - dest_dir: "/opt"
  gather_facts: True
  become: False

  tasks:
    - name: Verify host file.
      shell: cat "{{ src_dir }}/{{ host_file }}"
      register: list_host
      ignore_errors: True

    - name: Print out hosts.
      debug:
        # NOTE: Both syntax were accepted.
        # `var: list_hosts.stdout_lines`.
        var: "{{ list_host.stdout_lines }}"

    - name: Gathering checksum fact.
      shell: sha1sum "{{ src_dir }}/{{ file_name }}" | cut -d ' ' -f1
      register: checksum

    - name: Binding checksum to Ansible's variable.
      set_fact:
        hash_var: "{{ checksum.stdout }}"

    - name: Publish deployment script to all hosts.
      copy:
        src: "{{ src_dir }}/{{ file_name }}"
        dest: "{{ dest_dir }}/{{ file_name }}"
        checksum: "{{ hash_var }}"

    - name: Create installer directory.
      file:
        path: "{{ dest_dir }}/app"
        state: directory

    - name: Unarchive deployment target file.
      unarchive:
        src: "{{ dest_dir }}/{{ file_name }}"
        dest: "{{ dest_dir }}/app"

    - name: Running installer script.
      file:
        path: "{{ dest_dir }}/app/deploy/deployer.sh"
        mode: 0755

    - name: Execute installer script.
      shell: "{{ dest_dir }}/app/deploy/deployer.sh"
      register: installer_stdout

    - name: Debugger to show script's stdout.
      debug:
        var: installer_stdout
```

```bash
# Test:
ansible servers -i hosts -m shell -a "find /root -type f -iname \"*.j2\" | xargs cat"
# Alternative:
ansible servers -i hosts -m command -a "find /root -type f -iname \"*.j2\" | xargs cat"
```

- Jinja2 template specifications: produce reports within an elegant styling format.

  - {% ... %} for Statements. Eg: `{% for item in array %} ... {% endfor %}`.
  - {{ ... }} for Expressions to print to the template output. Eg: `{{ item.href }}`.
  - {# ... #} for Comments not included in the template output. Eg: `{# Single/multi-line(s) comment. #}`.
  - Filters: `{{ list_x | join(', ') }}` == `(str.join(', ', list_x))`.
  - Tests: `{% if loop.index is divisibleby 3 %}` == `{% if loop.index is divisibleby(3) %}`.
  - Escaping: `{% raw %} ... {% endraw %}`.
    NOTE: `{% raw -%}` tag cleans all the spaces and newlines preceding the first character of your raw data.
  - Child template:

  ```j2
  {% extends "base.html" %}
  {% block title %}Index{% endblock %}
  {% block head %}
    {{ super() }}
    <style type="text/css">
        .important { color: #336699; }
    </style>
  {% endblock %}
  {% block content %}
    <h1>Index</h1>
    <p class="important">
      Welcome to my awesome homepage.
    </p>
  {% endblock %}
  ```

```yml
# Jinja2 template deployment with ansible-playbook.
---
- name: Test populating .j2 template file.
  hosts: servers
  vars:
    arr: [0, 1, 2, 3, 4, 5]
    str: "Something just like this"
  become: False
  gather_facts: True

  tasks:
    - name: Deploy .j2 template to all hosts.
      template:
        src: template.j2
        dest: "/root/template.txt"
        owner: root
        group: root
        mode: "0644"
      loop:
        - Item1
        - Item2
        - Item3

    - name: Checking populated deployment process.
      shell: |
        find / -type f -iname "template.txt" || echo -n "Cannot found!\n"
      register: finding_res

    - name: Print-out debugging stdout.
      debug:
        # NOTE: Cannot use ansible variable filter here (because the `{{ finding_res }}` is undefined.)
        var: finding_res.stdout_lines # Error appeared: `{{ finding_res.stdout_lines | to_nice_yaml(indent=4) }}`
```

```j2
Jinja2 template at: {{ ansible_date_time.date }} {{ ansible_date_time.time }}.

Hostname: {{ ansible_nodename }}
System: {{ ansible_os_family }}
Proc: {{ ansible_processor_count }}

Testing template:
{#
    This is a block of comments.
    This is the end of comment block.
#}

Variable from `template.yml`: {{ str }}
Zip with Python: {{ arr | zip(['a', 'b', 'c', 'd', 'e', 'f']) | list }}

Example: Unknown Jinja2's binding variable behavior.
{% set new_list %}
    {{ arr | zip(['a', 'b', 'c', 'd', 'e', 'f']) | list }}
{% endset %}
Print: {{ new_list[3] }} --> Variable assigments was not supported.

For loop:
{% for num in arr %}
    {{ num | string | b64encode | b64decode }}
{% endfor %}
```

```yml
---
- name: Uptime monitoring.
  hosts: servers
  vars:
    delay: 5
    user:
      name: "IMpcuong"
      github: "https://github.com/IMpcuong"
  become: False
  gather_facts: True

  tasks:
    - name: Uptime calculation.
      shell: |
        uptime | cut -d ' ' -f4-5 | tr "," "\n"
      register: aliveness

    - name: Print to stdout.
      debug:
        var: aliveness.stdout

    - name: Looping with indices.
      debug:
        msg: "{{ idx }}: {{ item }}"
      loop:
        - Apple
        - Banana
        - Mango
      loop_control:
        index_var: idx

    - name: Daily report about the availability of each server.
      template:
        src: /root/template.j2
        dest: "/root/report.{{ ansible_date_time.iso8601_basic_short }}.txt"
      run_once: Yes
      delegate_to: localhost
```

```j2
System Validation at {{ ansible_date_time.time }} on {{ ansible_date_time.date }}:

{# NOTE: Indentations were preserved as ordinary of each line. #}

Unreachable system:
----------------------------------------------
{% for host in ansible_play_hosts_all %}
Report by: {{ hostvars[host].user.name }}, Github: {{ hostvars[host].user.github }}
{% if host not in ansible_play_hosts %}
    + Unavailable-host: {{ host }}
{% else %}
    + Available-host: {{ host }}
{% endif %}
{% endfor %}


Uptime report corresponding with each host:
----------------------------------------------
{% for host in ansible_play_hosts_all %}
{% if hostvars[host].uptime is defined %}
{% if 'day' not in hostvars[host].uptime.stdout %}
    + {{ hostvars[host].ansible_hostname }} - has not rebooted today!
{% endif %}
{% endif %}
{% endfor %}
```

- Execute third-party API using `uri` module:

```yml
# Execute third-party API using URI module.
---
- name: Execute third-party API using URI module.
  hosts: localhost
  vars:
    dude:
      name: "Hehe"
      age: "27"
      is_mafia: True
  gather_facts: True
  become: False
  tasks:
    - name: Collect data from foreign API.
      uri:
        method: GET
        return_content: True
        url: https://swapi.dev/api/people/
      register: peoples

    - name: Print first human that was being listed.
      debug:
        var: peoples.json.results[0]
```

- Secret credentials management using `ansible-vault`:

```bash
ansible-vault create secrets.yml
ansible-vault view secrets.yml
ansible-vault decrypt secrets.yml
ansible-vault encrypt secrets.yml
```

```out
ubuntu $ ansible-vault create dude.yml && ansible-vault create vault.yaml
ubuntu $ ansible-vault view dude.yml
username: "TheHeck"
password: "you ain't gonna made it dude"

ubuntu $ ansible-vault view vault.yaml
Vault password:
username: "dudedelay"
password: "vroom...vroom"

# Testing
ubuntu $ ansible-playbook vault_variables.yaml
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'
ERROR! Attempting to decrypt but no vault secrets found

ubuntu $ ansible-playbook --ask-vault-pass vault_variables.yaml

ubuntu $ echo "12345" > .passfile
ubuntu $ chmod 400 .passfile
ubuntu $ ansible-playbook --vault-password-file=.passfile vault_variables.yaml
```

```yml
# Secret vault/storage using ansible-vault
---
- name: Variable output testing
  hosts: localhost
  vars:
  vars_files:
    - dude.yml
    - vault.yaml
  gather_facts: True
  become: False
  tasks:
    - name: "Debug variables to view contents"
      debug:
        msg: "{{ item }} is in variable list"
      with_items:
        - "{{ username }}"
        - "{{ password }}"
# Output:
# ok: [localhost] => (item=dudedelay) => {
#     "msg": "dudedelay is in variable list"
# }
# ok: [localhost] => (item=vroom...vroom) => {
#     "msg": "vroom...vroom is in variable list"
# }
```

- The `hosts` file in the .ini extension syntax (with some extended attributes):

```ini
[servers]
controlplane env=prod app=db
node01 env=dev app=web
```

- The hosts file in the .yml (.yaml) extension syntax:

```yml
servers:
  hosts:
    controlplane:
      env: prod
      app: db
    node01:
      env: dev
      app: web
```

```yml
---
- name: MOTD Push. # NOTE: `MOTD` := Message Of The Day.
  hosts: servers
  vars:
  gather_facts: True
  become: True
  tasks:
    - name: Debug environment variables.
      debug:
        msg: "{{ ansible_nodename }}: {{ env }}"

    - name: Push over the file if prod-env matched.
      copy:
        src: /root/prod_motd
        dest: "/etc/motd"
      when: '"prod" in env'

    - name: Push over the file if dev-env matched.
      src: /root/dev_motd
        dest: "/etc/motd"
      when: '"dev" in env'

    - name: Test.
      shell: |
        cat /etc/motd
      register: test

    - name: Print output.
      debug:
        var: test.stdout_lines
```

- Gathering custom facts for each group:

```fact
// Prod-env patching-facts gathering: `prod_patching.fact`.
{
  "patch_group": "group2",
  "Rebooting":   "true",
  "appserver":   "true",
  "database":    "false",
  "webserver":   "false"
}
```

```fact
// Dev-env patching-facts gathering: `dev_patching.fact`.
{
  "patch_group": "group1",
  "Rebooting":   "false",
  "appserver":   "true",
  "database":    "false",
  "webserver":   "false"
}
```

```yml
# Custom patching-facts push to remote hosts: `custom_patch_push.yaml`.
---
- name: Patching facts push process.
  hosts: servers
  vars:
    - prod_patch: "prod_patching.fact"
    - dev_patch: "dev_patching.fact"
    - remote_dir: "/etc/ansible/facts.d"
  gather_facts: True
  become: True
  tasks:
    - name: Debug env-vars.
      debug:
        var: env

    - name: Create remote-dir contains corresponded patching facts.
      file:
        state: directory
        path: "{{ remote_dir }}"

    - name: Push over "{{ prod_patch }}" file.
      copy:
        src: "/root/{{ prod_patch }}"
        dest: "{{ remote_dir }}/patching.fact"
      when: '"prod" in env' # `env` := `env` property declared inside the hosts(.yml) file.

    - name: Push over "{{ dev_patch }}" file.
      copy:
        src: "/root/{{ dev_patch }}"
        dest: "{{ remote_dir }}/patching.fact"
      when: '"dev" in env' # `env` := `env` property declared inside the hosts(.yml) file.
```

```bash
# Testing:
ansible servers -i hosts -m shell -a 'ls /etc/ansible | grep -E ".*fact.*"'
ansible servers -i hosts -m shell -a 'cat /etc/ansible/facts.d/patching.fact'
```

```yml
# TODO: Port using our implementation later.
# Author's solution:
---
- name: System-facts and group-by those facts.
  hosts: servers
  vars:
  gather_facts: True
  become: True
  tasks:
    - name: Show Groups active in this playbook at start.
      debug:
        msg: "{{ group_names }}"

    - name: Setting groups for reboot-group.
      group_by:
        key: "{{ ansible_local.patching.patch_group }}"
      failed_when: false

    - name: Checking Rebooting flag.
      group_by:
        key: Rebooting
      when: '"true" in ansible_local.patching.Rebooting'

    - name: Show Groups active in this playbook at end.
      debug:
        msg: "{{ group_names }}"
```

```yml
# My solution:
---
- name: System-facts and group-by those facts.
  hosts: servers
  vars:
    - local_patch: "{{ ansible_local.patching }}"
  gather_facts: True
  become: False
  tasks:
    - name: Show active groups (starting point).
      debug:
        msg: "{{ group_names }}"

    - name: Setting each group with the reboot attribute.
      group_by:
        key: "{{ local_patch.patch_group }}" # The `patch_group` := defined the group contains each patching inside .fact file.
      failed_when: False

    - name: Checking the enabling status of the `Reboot` flag.
      group_by:
        key: Rebooting # Same as above.
      when: '"true" in ansible_local.patching.Rebooting'

    - name: Show active groups (ending point).
      debug:
        msg: "{{ group_names }}"
```

- Create user(s) automatically using `user` module:

```yml
# Automate user initiative process with `user` module.
---
- name: Create normal user for each hosts.
  hosts: servers
  vars:
    - role: admin
  gather_facts: True
  become: False
  tasks:
    - name: Env-debugger.
      debug:
        var: env

    - name: Create user for the dev-env.
      user:
        groups:
          - "{{ role }}"
          - root
        append: True
        uid: 8888
        password: "12345"
        home: /root/home/dev-engineer
        name: Dev-Engineer
        generate_ssh_key: True
        ssh_key_bits: 2048
        ssh_key_type: rsa
        ssh_key_file: .ssh/id_rsa
      when: '"dev" in env'

    - name: Create user for the dev-env.
      user:
        groups:
          - "{{ role }}"
          - root
        append: True
        uid: 8888
        password: "12345"
        home: /root/home/prod-engineer
        name: Prod-Engineer
        generate_ssh_key: True
        ssh_key_bits: 2048
        ssh_key_type: rsa
        ssh_key_file: .ssh/id_rsa
      when: '"prod" in env'

    - name: Collect groups name.
      shell: |
        grep -i engineer /etc/passwd && printf "\n"
        getent group | \
          awk -F ":" "{ print $1 }" | \
          grep -i "{{ env }}" # Shell-module is also accepted the playbook declarative variable(s).
      register: all_gr # `groups` := a builtin env-variable produces by Ansible-core.

    - name: Groups-debugger.
      debug:
        var: all_gr.stdout_lines
```

```bash
# Testing:
ansible servers -i hosts -m shell -a "grep -i engineer /etc/passwd; groups $(id -un)"
ansible servers -i hosts -m shell -a "grep -i engineer /etc/passwd; getent group root"
ansible servers -i hosts -m shell -a "grep -i engineer /etc/passwd; getent group | awk -F\":\" \"{ print $1 }\""
ansible servers -i hosts -m shell -a "ls -la .ssh"

ansible-playbook -i hosts user_create.yaml
# Output:
#
# ok: [controlplane] => {
#     "all_gr.stdout_lines": [
#         "Prod-Engineer:x:8888:8888::/root/home/prod-engineer:/bin/sh",
#         "root:x:0:Prod-Engineer",
#         "admin:x:117:Prod-Engineer",
#         "Prod-Engineer:x:8888:"
#     ]
# }
# ok: [node01] => {
#     "all_gr.stdout_lines": [
#         "Dev-Engineer:x:8888:8888::/root/home/dev-engineer:/bin/sh",
#         "root:x:0:Dev-Engineer",
#         "plugdev:x:46:ubuntu",
#         "admin:x:117:Dev-Engineer",
#         "netdev:x:118:ubuntu",
#         "Dev-Engineer:x:8888:"
#     ]
# }
```

- Package management using OS's corresponded tool:

```yml
# Update all OS's packages using its package manager (apt (dpkg option), yum, apk, pacman, yay, etc)
---
- name: Update OS's packages.
  hosts: servers
  vars:
  gather_facts: True
  become: False
  # remote_user: user # NOTE: Some tricky parts.
  # become_user: root
  tasks:
    - name: Using `apt` package manager manually.
      # Source: https://github.com/ansible/ansible/blob/devel/lib/ansible/modules/apt.py
      apt:
        # FIXME: Don't know root cause yet! (Err: "parameters are mutually exclusive: deb|package|upgrade")
        # upgrade: safe
        # upgrade: dist # NOTE: Equals to `apt-get dist-upgrade`
        state: present # NOTE: Discourage to upgrade to the `latest` version for any debian packages.
        autoclean: True
        autoremove: True
        name: "*"
```

````yml
# Install required packages if they are present.
---
- name: Install requirements list.
  hosts: servers
  vars:
    - apps:
        - apache2
        - php
        - mariadb-server
        - mariadb-client
  gather_facts: True
  become: True
  tasks:
    - name: Debugger env-vars from hosts file.
      debug:
        msg: "App: {{ app }}; Env: {{ env }}"

    - name: Install applications.
      apt:
        pkg:
          - "{{ apps[0] }}"
          - "{{ apps[1] }}"
      when: '"web" in app'

    - name: Install databases.
      apt:
        pkg:
          - "{{ apps[2] }}"
          - "{{ apps[3] }}"
        state: present
      when: '"db" in app'

    - name: Checking whether installation successful or not.
      # Cmd: `dpkg --list "{{ item }}"`

      # NOTE: The default shell `/bin/sh` (register with: `ansible_shell_type`)
      #   cannot absorb the `/bin/bash` shell's syntax. We can improve this by
      #   re-assign the `ansible_shell_type` in the `ansible.cfg` file.
      #
      #   Cmd: `find / -type f ! -empty -iname "ansible.cfg"` ("/etc/ansible/ansible.cfg")
      #
      #   Solution:
      #   ```cfg
      #   [defaults]
      #   executable = /bin/bash
      #   ```
      shell: |
        declare -x app_stat=$(apt list "{{ item }}")
        if [[ ${app_stat} == *"installed"* || ${app_stat} == *"upgradable"* ]]; then
          printf "Installation successful %s\n" "{{ item }}"
        else
          printf "%s Oops!!!\n" "{{ item }}"
        fi
      loop: "{{ apps | list }}"
      register: ins_status

    - name: Validation output status.
      debug:
        msg: "{{ item.stdout }}"
      loop: "{{ ins_status.results | list }}"
````

```yml
# Optional looping example:
- name: Touch files with an optional mode
  ansible.builtin.file:
    dest: "{{ item.path }}"
    state: touch
    mode: "{{ item.mode | default(omit) }}"
  loop:
    - path: /tmp/foo
    - path: /tmp/bar
    - path: /tmp/baz
      mode: "0444"
```

- Role(s) governance using `ansible-galaxy`:

```bash
# Create new role using ansible-galaxy:
cd playbook/roles && \
  ansible-galaxy init update && \
  ansible-galaxy init install

ansible-galaxy role init update --init-path playbook/roles/
ansible-galaxy role init install --init-path playbook/roles/

# Running both tags:
ansible-playbook -i hosts.yml stack.yml

# Running with specific tag:
ansible-playbook -i hosts.yml stack.yml --tag=upgrade
ansible-playbook -i hosts.yml stack.yml --tag=install

```

```out
controlplane $ tree -L 3
.
|-- hosts.yml
|-- install
|   |-- README.md
|   |-- defaults
|   |   `-- main.yml
|   |-- files
|   |-- handlers
|   |   `-- main.yml
|   |-- meta
|   |   `-- main.yml
|   |-- tasks
|   |   |-- install.yml
|   |   `-- main.yml
|   |-- templates
|   |-- tests
|   |   |-- inventory
|   |   `-- test.yml
|   `-- vars
|       `-- main.yml
|-- stack.yml
`-- update
    |-- README.md
    |-- defaults
    |   `-- main.yml
    |-- files
    |-- handlers
    |   `-- main.yml
    |-- meta
    |   `-- main.yml
    |-- tasks
    |   |-- main.yml
    |   `-- update.yml
    |-- templates
    |-- tests
    |   |-- inventory
    |   `-- test.yml
    `-- vars
        `-- main.yml

18 directories, 20 files
```

```yml
# hosts.yml
servers:
  hosts:
    controlplane:
      env:
        - prod
      app:
        - web
    node01:
      env:
        - dev
      app:
        - db
```

```yml
# stack.yml || env.yml
---
- name: Stack-playbook.
  hosts: servers
  gather_facts: True
  become: True
  roles:
    - update
    - install
```

```yml
# upgrade/tasks/main.yml (include `---`)
---
# tasks file for update
- include_tasks: update.yml
  tags:
    - update

# upgrade/tasks/update.yml
- name: Upgrade distro's packages to latest version.
  apt:
    name: "*"
    state: latest
  tags:
    - update
```

```yml
# install/tasks/main.yml (include `---`)
---
# tasks file for install
- include_tasks: install.yml
  tags:
    - install

# install/tasks/install.yml
- name: Install all required web-application packages.
  apt:
    pkg:
      - apache2
      - php
  when: '"web" in app'
  tags:
    - install

- name: Install all required database packages.
  apt:
    pkg:
      - mariadb-server
      - mariadb-client
  when: '"db" in app'
  tags:
    - install
```
