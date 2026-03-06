# Building a Secure DMZ: Static NAT & Extended ACLs

## Project Context
The objective of this project was to securely host a public-facing corporate web server without exposing the internal private network to external threats. This required architecting a Demilitarized Zone (DMZ) to physically and logically isolate the server, while using port forwarding to allow outside internet traffic to reach it.

## Non-Technical Summary: What Does This Project Do?
* **The Problem:** The company needs to host a website, but placing a public server on the same network as internal employee computers is a massive security risk. If a hacker compromises the web server, they have free rein over the company's private data. 
* **The Solution:** I created an isolated "quarantine" network (a DMZ). I then configured the main router to take any web traffic hitting the company's public internet address and forward it exclusively to this server. Finally, I implemented a strict digital firewall rule ensuring that while the server can talk to the internet, it is completely blocked from reaching back into the private employee networks.

## Network Topology

*<img width="434" height="316" alt="Day_5_topology" src="https://github.com/user-attachments/assets/45c1f101-560a-44f9-b5bd-ab346f221ec6" />*

---

## Technical Deep-Dive

### Technologies & Protocols Implemented
* **Network Segmentation:** VLAN 30 (DMZ), 802.1Q Trunking, Router-on-a-Stick Subinterfaces.
* **Address Translation:** Static NAT (Port Forwarding for TCP Port 80).
* **Security & Traffic Filtering:** Extended Access Control Lists (ACLs), Inbound Interface Application.

### Configuration Highlights

#### 1. Static NAT (Port Forwarding)
Configured the edge router to permanently map the public interface IP on port 80 (HTTP) to the internal private IP of the DMZ server.

```
interface GigabitEthernet0/1.30
 ip nat inside
!
ip nat inside source static tcp 192.168.3.10 80 203.0.113.2 80
```
2. Extended ACL for DMZ Isolation
Created an Extended ACL to explicitly deny IP traffic originating from the DMZ subnet destined for the internal Sales and Engineering subnets, while permitting outbound traffic to the public internet.

```
access-list 100 deny ip 192.168.3.0 0.0.0.255 192.168.1.0 0.0.0.255
access-list 100 deny ip 192.168.3.0 0.0.0.255 192.168.2.0 0.0.0.255
access-list 100 permit ip any any
!
interface GigabitEthernet0/1.30
 ip access-group 100 in
```

Verification & Troubleshooting
VLAN Trunking Resolution: During initial testing, the DMZ server could not reach its default gateway. Troubleshooting Layer 2 revealed the switch's uplink trunk port had a restricted allowed VLAN list. I added VLAN 30 to the trunk, restoring connectivity.

NAT Verification: Static Routing Verification: Executed show ip nat translations on the HQ router to confirm the static port forwarding rule was actively mapping the public IP (203.0.113.2:80) to the internal DMZ server (192.168.3.10:80). 

<img width="424" height="106" alt="static_nat_translations" src="https://github.com/user-attachments/assets/1792c981-ab9d-4fbb-9b41-b2188e03b5ab" />


Successfully loaded the custom HTML index page from an external client on the simulated public internet. 

<img width="431" height="296" alt="dmz_website_live" src="https://github.com/user-attachments/assets/6964ac18-b16d-4766-8714-9f4948357c1f" />



Security Verification: Attempted to ping the internal Sales VLAN from the DMZ Web Server. The traffic was successfully dropped by the router, logging matches on the Extended ACL. 

<img width="431" height="296" alt="dmz_website_live" src="https://github.com/user-attachments/assets/18617020-f928-4953-9f1c-98ab156581d3" />

<img width="427" height="129" alt="acl_hit_counters" src="https://github.com/user-attachments/assets/c4f45676-4840-4483-8791-b532d839e7c7" />


