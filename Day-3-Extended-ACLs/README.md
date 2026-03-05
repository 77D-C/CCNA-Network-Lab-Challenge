# Day 3: Internal Network Security & Traffic Filtering with Extended ACLs

## Project Context
For the third day of my Cisco Packet Tracer lab sprint, the focus shifted away from physical topology expansion and entirely toward logical access control.
While today's project didn't expand the network's footprint, the configurations applied drastically strengthened its internal security posture.

## Non-Technical Summary: What Does This Project Do?
* **The Problem:**
*  In a corporate environment, just because an employee is connected to the company network doesn't mean they should have access to every internal resource.
*  In this scenario, the company required that the remote Branch Office be able to communicate with the Sales department, but be strictly blocked from accessing the Engineering department's confidential servers.
* **The Solution:**
* I implemented an internal firewall rule known as an Extended Access Control List (ACL). I placed this rule at the Branch Office router to intercept traffic before it even crosses the WAN link.
* If a Branch PC tries to talk to Sales, the router lets it through. If it tries to talk to Engineering, the router quietly drops the data.

## Network Topology

<img width="919" height="455" alt="day3" src="https://github.com/user-attachments/assets/d0ef4be3-1874-4e69-a1ac-13936c58e785" />


---

## Technical Deep-Dive

### Security Policy Requirements
* **Permit:** ICMP and IP traffic from Branch LAN (`192.168.2.0/24`) to HQ Sales VLAN (`192.168.1.0/26`).
* **Deny:** ICMP and IP traffic from Branch LAN (`192.168.2.0/24`) to HQ Engineering VLAN (`192.168.1.64/26`).
* **Placement Strategy:** Applied inbound on the Branch Router's LAN interface (`GigabitEthernet0/0`) to filter traffic closest to the source, preserving WAN bandwidth.

### Technologies & Protocols Implemented
* **Security:** Extended IPv4 Access Control Lists (Numbered 100-199).
* **Core Concepts:** Implicit Deny, Wildcard Masking (`0.0.0.63` and `0.0.0.255`), Inbound vs. Outbound Interface Application.

### Configuration Highlights

#### 1. Defining the Extended ACL (Branch Router)
Configured the specific permit and deny statements using wildcard masks to target the exact subnets.

 Block Branch LAN from reaching the Engineering VLAN
 ```
access-list 100 deny ip 192.168.2.0 0.0.0.255 192.168.1.64 0.0.0.63
```

 Permit all other legitimate business traffic
 ```
access-list 100 permit ip any any
```
2. Applying the ACL to the Interface
Assigned the ACL to act as an inbound filter on the gateway interface.

```
interface GigabitEthernet0/0
 ip access-group 100 in
```
Verification & Troubleshooting
Testing security policies requires verifying both the positive and negative conditions.

Verifying Permitted Traffic: Successfully sent ICMP echo requests from the Branch PC (192.168.2.2) to the Sales PC (192.168.1.2). 

Verifying Denied Traffic: Attempted to ping the Engineering PC (192.168.1.66) from the Branch PC. The traffic was successfully blocked, resulting in a Destination host unreachable reply from the gateway. 
