- *RBAC* stands for "_Role-Based Access Control_" and it is indeed an authorization technique commonly used in Kubernetes (k8s) to control and manage access to resources within a Kubernetes cluster:

  - _RBAC_ defines _fine-grained permissions_ by _creating roles and role_ bindings that _specify_ what actions are allowed on which resources for different users, groups, or service accounts.

  - _RBAC_ is a fundamental aspect of securing Kubernetes clusters and ensuring that _only authorized entities_ can _interact with resources_.

  - Here's a brief overview of the key components in _Kubernetes RBAC_:

    - _Roles_: A role defines a set of rules that specify which actions (verbs) are allowed on which resources (API groups, resources, and resource names) within a given namespace. Roles are specific to a namespace.

    - _ClusterRoles_: Similar to roles, but they apply across the entire cluster and are not restricted to a specific namespace.

    - _RoleBindings_: A role binding associates a role with a user, group, or service account within a specific namespace, granting them the permissions defined in the associated role.

    - _ClusterRoleBindings_: Similar to role bindings, but they apply cluster-wide and are not restricted to a specific namespace.

- CSI, CNI, and CRD terminologies on k8s, visualize pictorially by a table format:

  |      Term         |        Full Form         |       Description          |                Purpose                     |
  |-------------------|--------------------------|----------------------------|--------------------------------------------|
  |       CSI         | Container Storage        | Standardized interface     | Manage storage volumes attached to         |
  |                   | Interface                | for storage plugins to     | containers.                                |
  |                   |                          | communicate with runtimes. |                                            |
  |                   |                          |                            |                                            |
  |       CNI         | Container Network        | Specification and plugins   | Manage container networking and            |
  |                   | Interface                | for setting up container   | connectivity.                              |
  |                   |                          | networking.                |                                            |
  |                   |                          |                            |                                            |
  |       CRD         | Custom Resource          | Extension mechanism for    | Extend Kubernetes with custom resources    |
  |                   | Definition                | defining custom resources   | and associated controllers.                |
  |                   |                          | and APIs.                  |                                            |

- In Kubernetes, an "*Operator*" is a concept and a pattern for managing complex applications and services using custom controllers.

  - *Operators* extend the Kubernetes API to automate the management of applications that require domain-specific knowledge and complex operational logic.

- Curated table of some _important kind values_ you might encounter in Kubernetes _manifest specification files_:

  | Kind                           | Description                                                                                     |
  |------------------------------- | ----------------------------------------------------------------------------------------------- |
  | Pod                            | A basic deployable unit in Kubernetes that holds one or more containers.                        |
  | Service                        | Exposes a set of Pods as a network service with a stable IP and DNS name.                       |
  | Deployment                     | Manages the deployment of replica sets and provides declarative updates to applications.        |
  | StatefulSet                    | Manages the deployment and scaling of a set of stateful pods with unique network identities.    |
  | DaemonSet                      | Ensures that a copy of a pod is running on each node in the cluster.                            |
  | Job                            | Runs a task or a set of tasks to completion, such as batch processing or data migration.        |
  | CronJob                        | Creates Jobs on a schedule, similar to cron jobs in UNIX systems.                               |
  | Namespace                      | Provides a way to logically isolate resources within a cluster.                                 |
  | ConfigMap                       | Holds configuration data for applications as key-value pairs or as files.                         |
  | Secret                         | Stores sensitive information, such as passwords, tokens, or keys.                               |
  | ServiceAccount                 | Provides an identity for processes running in a Pod to access the Kubernetes API and resources. |
  | PersistentVolume               | Represents a storage resource in the cluster that can be mounted to Pods.                       |
  | PersistentVolumeClaim          | Requests storage resources and binds them to PersistentVolumes.                                 |
  | Ingress                        | Manages external access to services within the cluster, typically for HTTP(S) traffic.           |
  | Role                           | Defines permissions for accessing resources within a namespace.                                  |
  | ClusterRole                    | Defines permissions for accessing cluster-level resources.                                       |
  | RoleBinding                    | Binds a Role to a user, group, or service account within a namespace.                           |
  | ClusterRoleBinding             | Binds a ClusterRole to a user, group, or service account at the cluster level.                  |
  | CustomResourceDefinition (CRD)  | Defines custom resources and their behavior, enabling Operators.                                 |
  | ServiceMonitor                 | Used in conjunction with monitoring tools to configure scraping of service metrics.              |
