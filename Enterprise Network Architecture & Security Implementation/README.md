# 🏢 Enterprise Network Architecture & Security Implementation

![Cisco](https://img.shields.io/badge/Cisco-1BA0D7?style=for-the-badge&logo=cisco&logoColor=white)
![CCNA](https://img.shields.io/badge/CCNA-Routing_%26_Switching-blue?style=for-the-badge)
![Network+](https://img.shields.io/badge/CompTIA-Network+-red?style=for-the-badge)

> A comprehensive, multi-site enterprise network deployment simulating a real-world Headquarters and Branch office infrastructure. This capstone project demonstrates end-to-end network engineering, from core routing and high availability to centralized wireless management and strict Layer 2 security hardening.

---

## 📋 Project Overview

The objective of this deployment was to build a network from the ground up that guarantees uptime, provides centralized network visibility, supports scalable wireless access, and enforces strict physical and remote security boundaries. The architecture supports a primary Headquarters (HQ) and a remote Branch office, built with enterprise-grade resilience in mind.

![Network Topology](link_to_your_topology_image.png)
*(Note: Upload a screenshot of your full Packet Tracer topology here)*

---

## 🛠️ Deployment Phases

### Phase 1: Core Infrastructure & Routing
*Objective: Establish the foundational LAN/WAN routing, VLAN segmentation, and IP address management.*

* **Network Segmentation:** Engineered strict broadcast domains using IEEE 802.1Q VLANs to isolate Sales, Engineering, and Management traffic, reducing congestion and limiting blast radiuses.
* **Inter-VLAN Routing:** Deployed a Router-on-a-Stick (ROAS) architecture for efficient internal routing between departments.
* **Dynamic IP Allocation:** Configured internal DHCP pools to dynamically assign IP addresses to end-user devices while explicitly excluding critical infrastructure IPs.
* **DMZ Deployment:** Isolated public-facing web servers in a dedicated Demilitarized Zone (DMZ) to protect the internal corporate LAN from external threat vectors.

### Phase 2: High Availability & Gateway Redundancy
*Objective: Eliminate single points of failure at the core routing layer to ensure zero downtime for end-users.*

* **First Hop Redundancy:** Deployed Hot Standby Router Protocol (HSRP) across the HQ campus.
* **Automated Failover:** Configured an Active/Standby gateway relationship with preemptive routing. Successfully simulated catastrophic hardware failure, verifying that internal traffic transparently failed over to the backup router with no connection loss.

![HSRP Failover Proof](link_to_hsrp_failover_ping.png)
*(Note: Upload your `hsrp_failover_ping.png` here)*

### Phase 3: Centralized Management & Telemetry
*Objective: Consolidate network logging and time synchronization across all hardware for streamlined troubleshooting and incident response.*

* **Centralized Syslog:** Configured all edge routers and core switches to forward operational logs to a centralized management server, providing single-pane-of-glass visibility into interface states and security events.
* **NTP Synchronization:** Deployed a central Network Time Protocol (NTP) server to ensure millisecond-accurate timestamping across all device logs, a critical requirement for accurate forensic analysis.

![Syslog Dashboard](link_to_syslog_campus_centralized.png)
*(Note: Upload your `syslog_campus_centralized.png` here)*

### Phase 4: Enterprise Wireless Infrastructure
*Objective: Transition from autonomous access points to a scalable, centrally managed enterprise wireless environment.*

* **Wireless LAN Controller (WLC):** Deployed a Cisco 3504 WLC to centralize management, authentication, and radio frequency (RF) policies.
* **CAPWAP Architecture:** Integrated Lightweight Access Points (LAPs) that dynamically download configurations directly from the WLC.
* **Layer 3 Discovery:** Configured DHCP Option 43 on the branch router, allowing LAPs to automatically locate the WLC across different IP subnets.
* **Wireless Security:** Built and broadcasted the `Branch-Corp` SSID, securing it with WPA2-PSK (AES) encryption to ensure data confidentiality over the air.

![WLC Dashboard](link_to_wlc_dashboard_active.png)
*(Note: Upload your `wlc_dashboard_active.png` here)*

### Phase 5: Layer 2 Hardening & Access Security
*Objective: Implement a "Zero Trust" model at the physical layer to protect against unauthorized access and rogue devices.*

* **Port Security:** Locked down user access switch ports by tying them to specific MAC addresses (`mac-address sticky`). Configured violation modes to immediately shut down the port (`err-disable`) if a rogue device is connected.
* **Blackhole VLAN:** Mitigated the risk of unauthorized physical access by administratively shutting down all unused switch ports and isolating them in a non-routed "Blackhole" VLAN (VLAN 999).
* **Encrypted Management:** Hardened remote device administration by disabling legacy Telnet access, generating RSA crypto keys, and forcing secure, encrypted SSHv2 connections.

![Port Security Trap](link_to_port_security_config.png)
*(Note: Upload your `port_security_config.png` here)*

---

## 🧰 Technologies & Protocols Demonstrated

| Category | Technologies |
|---|---|
| **Routing & Switching** | VLANs, 802.1Q Trunking, ROAS, Static Routing, PortFast |
| **High Availability** | HSRP, Spanning Tree Protocol (STP) |
| **Infrastructure Services** | DHCP, DNS, NTP, Syslog |
| **Wireless** | WLC (3504), Lightweight APs, CAPWAP, DHCP Option 43, WPA2 |
| **Security** | Port Security, Sticky MAC, Blackhole VLANs, SSHv2, RSA Encryption |

---
*This repository serves as a practical demonstration of skills required for Junior Network Administrator and NOC Technician roles.*
