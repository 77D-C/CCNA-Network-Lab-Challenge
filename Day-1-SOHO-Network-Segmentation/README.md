# Day 1: SOHO Network Segmentation & Automated IP Provisioning

## Project Context
This project is part of a 7-day Cisco Packet Tracer lab sprint designed to translate theoretical networking concepts into practical, hands-on configurations. 
Following the completion of my degree in Cyber Security, as well as obtaining my CompTIA Network+ and Cisco CCNA certifications.
These labs demonstrate my ability to design, configure, and troubleshoot enterprise networking environments.

## Non-Technical Summary: What Does This Project Do?
Imagine a small startup that just moved into a new office. They have a Sales team and an Engineering team sharing the same network cables. 

* **The Problem:**
*  If everyone is on the exact same network, the background chatter from all the computers slows things down.
*  That creates a security risk (Sales shouldn't necessarily see Engineering's private servers).
*  Also, manually setting up the network connection for every new computer they buy takes too much time.
* **The Solution:**
* I built a virtual network that splits the physical equipment into two separate, secure "virtual" networks (one for Sales, one for Engineering).
* Then, I programmed the main router to automatically hand out network addresses to any new computer plugged into the wall, saving time and preventing human error. 

## Network Topology
<img width="660" height="586" alt="image" src="https://github.com/user-attachments/assets/60fa36c8-4c78-46ad-840f-38f770932e83" />


## Technical Deep-Dive

### Network Addressing Scheme
Utilizing a standard Class C network (`192.168.1.0/24`) and divided it into smaller subnets using a `/26` mask. This creates efficient, isolated broadcast domains (VLANs).

| Department   | VLAN ID | Network Address     | Default Gateway | DHCP Pool Range             |
| :---         | :---    | :---                | :---            | :---                        |
| Sales        | 10      | 192.168.1.0 /26     | 192.168.1.1     | 192.168.1.2 - 192.168.1.62  |
| Engineering  | 20      | 192.168.1.64 /26    | 192.168.1.65    | 192.168.1.66 - 192.168.1.126|

### Technologies & Protocols Implemented
* **Layer 2 Infrastructure (The Switch):** VLAN Configuration, 802.1Q Trunking (creating a "superhighway" for both departments' data to travel on), Access Port assignment.
* **Layer 3 Routing (The Router):** Inter-VLAN Routing utilizing "Router-on-a-Stick" (allowing the two separate departments to still talk to each other when necessary using just one physical cable).
* **Network Services:** Cisco IOS DHCP Server configuration (the automated system handing out IP addresses).

### Configuration Highlights

#### 1. DHCP Pool & Exclusions (Automated IP Addressing)
To prevent the router from accidentally giving out its own address to a random computer, the default gateways were excluded before establishing the address pools.
```text
ip dhcp excluded-address 192.168.1.1
ip dhcp excluded-address 192.168.1.65

ip dhcp pool SALES
 network 192.168.1.0 255.255.255.192
 default-router 192.168.1.1
 dns-server 8.8.8.8
