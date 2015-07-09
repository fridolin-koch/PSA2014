base_utils Cookbook
===================

This cookbook configures dotdeb and installs the following utilities:

* htop
* git
* python-pip
* vom
* curl

If the node is tagged with `aws` this cookbook will install the route53 auto DNS update script ('cli53'). It will also install the [ec2-metadata tools](http://aws.amazon.com/code/1825).


Requirements
------------

Debian 7

e.g.
#### packages
- `apt` - base_utils needs toaster to brown your bagel.

Attributes
----------

#### base_utils::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['dns']['ttl']</tt></td>
    <td>Integer</td>
    <td>The DNS ttl</td>
    <td><tt>900</tt></td>
  </tr>
  <tr>
    <td><tt>['dns']['zone']</tt></td>
    <td>String</td>
    <td>The DNS zone</td>
    <td><tt>airmotion.de</tt></td>
  </tr>
</table>

Usage
-----
#### base_utils::default

e.g.
Just include `base_utils` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[base_utils]"
  ]
}
```

