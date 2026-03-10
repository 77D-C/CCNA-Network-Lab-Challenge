# 🏢 Enterprise Network Architecture & Security Implementation

![Cisco](https://img.shields.io/badge/Cisco-1BA0D7?style=for-the-badge&logo=cisco&logoColor=white)
![CCNA](https://img.shields.io/badge/CCNA-Routing_%26_Switching-blue?style=for-the-badge)
![Network+](https://img.shields.io/badge/CompTIA-Network+-red?style=for-the-badge)

> A comprehensive, multi-site enterprise network deployment simulating a real-world Headquarters and Branch office infrastructure. This capstone project demonstrates end-to-end network engineering, from core routing and high availability to secure IPsec WAN connectivity, centralized wireless management, and strict Layer 2 security hardening.

---

## 📋 Project Overview

The objective of this deployment was to build a network from the ground up that guarantees uptime, secures data across public infrastructure, supports scalable wireless access, and enforces strict physical boundaries. The architecture supports a primary Headquarters (HQ) and a remote Branch office, built with enterprise-grade resilience in mind.


*<img width="626" height="343" alt="day-7_topology" src="https://github.com/user-attachments/assets/00e995f2-1034-4bcc-9537-44151c6f15d8" />*

---

## 🛠️ Deployment Phases

### Phase 1: Core Infrastructure & Routing
*Objective: Establish the foundational LAN routing, VLAN segmentation, and IP address management.*

* **Network Segmentation:** Engineered strict broadcast domains using IEEE 802.1Q VLANs to isolate Sales, Engineering, and Management traffic, reducing congestion and limiting blast radiuses.
* **Inter-VLAN Routing:** Deployed a Router-on-a-Stick (ROAS) architecture for efficient internal routing between departments.
* **Dynamic IP Allocation:** Configured internal DHCP pools to dynamically assign IP addresses to end-user devices while explicitly excluding critical infrastructure IPs.
* **DMZ Deployment:** Isolated public-facing web servers in a dedicated Demilitarized Zone (DMZ) to protect the internal corporate LAN from external threat vectors.

### Phase 2: High Availability & Gateway Redundancy
*Objective: Eliminate single points of failure at the core routing layer to ensure zero downtime for end-users.*

* **First Hop Redundancy:** Deployed Hot Standby Router Protocol (HSRP) across the HQ campus.
* **Automated Failover:** Configured an Active/Standby gateway relationship with preemptive routing. Successfully simulated catastrophic hardware failure, verifying that internal traffic transparently failed over to the backup router with no connection loss.


*<img width="635" height="311" alt="hsrp_failover_ping" src="https://github.com/user-attachments/assets/e938e189-5312-46a8-9f16-2739d342248d" />*


### Phase 3: Secure WAN Connectivity & Centralized Telemetry
*Objective: Bridge the remote sites securely over the public internet and consolidate network logging.*

* **Site-to-Site IPsec VPN:** Architected a secure VPN tunnel over the simulated ISP to bridge the HQ and Branch office LANs. Configured ISAKMP Phase 1/Phase 2 policies, Transform Sets, Crypto Maps, and Access Control Lists (ACLs) to encrypt and encapsulate inter-site traffic.
* **Centralized Syslog:** Routed management traffic securely through the VPN tunnel, configuring edge routers and core switches to forward operational logs to a centralized HQ management server for single-pane-of-glass visibility.
* **NTP Synchronization:** Deployed a central Network Time Protocol (NTP) server to ensure millisecond-accurate timestamping across all device logs for forensic analysis.


*<img width="1148" height="259" alt="syslog_campu_centralized" src="https://github.com/user-attachments/assets/6dcc53f3-66f1-421e-b23b-87c2fdf5efa1" />*

### Phase 4: Enterprise Wireless Infrastructure
*Objective: Transition from autonomous access points to a scalable, centrally managed enterprise wireless environment.*

* **Wireless LAN Controller (WLC):** Deployed a Cisco 3504 WLC to centralize management, authentication, and radio frequency (RF) policies.
* **CAPWAP Architecture:** Integrated Lightweight Access Points (LAPs) that dynamically download configurations directly from the WLC.
* **Layer 3 Discovery:** Configured DHCP Option 43 on the Branch router, allowing LAPs to automatically locate the WLC across different IP subnets.
* **Wireless Security:** Built and broadcasted the `Branch-Corp` SSID, securing it with WPA2-PSK (AES) encryption.


*<img width="1148" height="259" alt="syslog_campu_centralized" src="https://github.com/user-attachments/assets/12bcdfb7-ab31-49d2-ba4a-f44bf908d7d1" />*

### Phase 5: Layer 2 Hardening & Access Security
*Objective: Implement a "Zero Trust" model at the physical layer to protect against unauthorized access and rogue devices.*

* **Port Security:** Locked down user access switch ports by tying them to specific MAC addresses (`mac-address sticky`). Configured violation modes to immediately shut down the port (`err-disable`) if a rogue device is connected.
* **Blackhole VLAN:** Mitigated the risk of unauthorized physical access by administratively shutting down all unused switch ports and isolating them in a non-routed "Blackhole" VLAN (VLAN 999).
* **Encrypted Management:** Hardened remote device administration by disabling legacy Telnet access, generating RSA crypto keys, and forcing secure, encrypted SSHv2 connections.


*<img width="289" height="170" alt="port_security_config" src="https://github.com/user-attachments/assets/06ae317c-19c1-4667-beb8-6ecf3b8684e9" />*


---

## 🧰 Technologies & Protocols Demonstrated

| Category | Technologies |
|---|---|
| **Routing & Switching** | VLANs, 802.1Q Trunking, ROAS, Static Routing, PortFast |
| **WAN & VPN** | IPsec, ISAKMP, Crypto Maps, Transform Sets, ACLs |
| **High Availability** | HSRP, Spanning Tree Protocol (STP) |
| **Infrastructure Services** | DHCP, DNS, NTP, Syslog |
| **Wireless** | WLC (3504), Lightweight APs, CAPWAP, DHCP Option 43, WPA2 |
| **Security** | Port Security, Sticky MAC, Blackhole VLANs, SSHv2, RSA |

---
*This repository serves as a practical portfolio demonstration of the enterprise routing, switching, and security competencies for Junior Network Administrator and NOC Technician roles*
