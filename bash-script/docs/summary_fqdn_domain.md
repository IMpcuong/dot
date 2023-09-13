- *FQDN* stands for "_*Fully Qualified Domain Name*_".
  It is a complete and unambiguous domain name that specifies the exact location of a resource within the hierarchical structure of the _Domain Name System (DNS)_.
  An FQDN includes not only the actual hostname but also the entire hierarchy of domain labels that lead to it, from the top-level domain down to the specific host.

- An *FQDN* is composed of several parts:

  - _Hostname_: This is the specific name given to a device or resource on a network. For example, in the FQDN "www.example.com," "www" is the hostname.

  - _Domain_: A domain represents a grouping of devices or resources under a common administrative authority. In the FQDN "www.example.com," "example" is the domain.

  - _Top-Level Domain (TLD)_: This is the highest level of the domain hierarchy. Common TLDs include ".com," ".org," ".net," and country-code TLDs like ".uk" for the United Kingdom or ".ca" for Canada.

  - _Second-Level Domain (SLD_): This comes before the top-level domain and is usually the name chosen by an organization or entity to represent themselves online. In "www.example.com," "example" is the second-level domain.

  - _Subdomains_: These are additional levels of organization within a domain. For instance, "www" is a subdomain of "example.com."

- The *ndots* option/directive in the _/etc/resolv.conf_ file is used to control the behavior of DNS name resolution in Linux systems.
  This option specifies the number of dots (periods) that a hostname should contain in order for the resolver to consider it a fully qualified domain name (FQDN) and not append the default domain suffix to it.

  - Here's how it works:

    - If a hostname contains at least as many dots as the value specified in the *ndots* directive, the resolver considers it a fully qualified domain name (FQDN) and doesn't append the default domain suffix.

    - If a hostname contains fewer dots than the value specified in the *ndots* directive, the resolver appends the default domain suffix to it before attempting to resolve.

- NOTE:
  - Putting it all together, the *FQDN* "www.example.com" specifies that the resource is located at the host named "www" within the "example.com" domain.
  - *FQDNs* are important for accurate and unambiguous addressing in network communications. They are used to uniquely identify resources on the internet and within private networks, facilitating the proper routing of data.