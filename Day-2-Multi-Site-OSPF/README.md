# Day 2: Multi-Site OSPF Expansion & Centralized DHCP Management

## Project Context
Continuing my 7-day Cisco Packet Tracer lab sprint, Day 2 focuses on scaling the Day 1 SOHO network into a multi-site enterprise environment. This lab demonstrates my ability to configure Wide Area Network (WAN) links, implement dynamic routing protocols, and centralize network services across multiple geographic locations.

## Non-Technical Summary: What Does This Project Do?
* **The Problem:** The startup from Day 1 opened a remote Branch Office. The new employees need access to the network, but manually programming routes between the buildings is inefficient. Furthermore, managing separate IP address pools at every physical location creates administrative overhead.
* **The Solution:** I established a simulated point-to-point WAN connection between the two buildings and configured OSPF (Open Shortest Path First) so the routers automatically share their network maps. To streamline administration, I set up the Branch router to intercept IP address requests and forward them across the WAN to the Headquarters router, allowing HQ to centrally manage all IP addresses for the entire company.

## Network Topology



---

## Technical Deep-Dive

### Network Addressing Scheme
Added a `/30` point-to-point transit link to conserve IP addresses, along with a new standard Class C subnet for the Branch Office LAN.

| Location | Network Purpose | Network Address | Subnet Mask | Wildcard Mask (OSPF) |
| :--- | :--- | :--- | :--- | :--- |
| **WAN** | Transit Link | 10.0.0.0 /30 | 255.255.255.252 | 0.0.0.3 |
| **Branch** | General LAN | 192.168.2.0 /24 | 255.255.255.0 | 0.0.0.255 |

### Technologies & Protocols Implemented
* **Dynamic Routing:** Single-Area OSPFv2 (Process ID 1, Area 0).
* **Network Services:** Centralized DHCP Management, DHCP Relay (`ip helper-address`).
* **Core Concepts:** Wildcard Masking, Routing Table Analysis, Packet Tracer Simulation Mode Diagnostics.

### Configuration Highlights

#### 1. Centralized DHCP Pool (HQ Router)
Configured the HQ router to manage the IP scope for the remote branch.
```text
ip dhcp excluded-address 192.168.2.1
ip dhcp pool BRANCH
 network 192.168.2.0 255.255.255.0
 default-router 192.168.2.1
 dns-server 8.8.8.8
