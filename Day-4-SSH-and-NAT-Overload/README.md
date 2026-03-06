# Day 4: Securing the Management Plane & Implementing NAT Overload

## Project Context
For Day 4 of this network engineering lab sprint, the objective was to safely connect our internal infrastructure to the outside world.
Before opening any routes to the internet, it was critical to establish a security-first baseline by locking down how the network devices themselves are managed. 

## Non-Technical Summary: What Does This Project Do?
* **The Security Problem:** Out of the box, network routers default to unencrypted management protocols. If an administrator logs in, their password travels across the network in plain text. 
* **The Connectivity Problem:** The internal computers use private IP addresses. If they try to send data to the public internet, the internet doesn't know how to route the replies back to them.
* **The Solution:**
* First, I disabled unencrypted access and configured Secure Shell (SSH), ensuring all management traffic to the headquarters router is heavily encrypted.
* Second, I simulated an ISP connection and implemented NAT Overload (Port Address Translation). This acts like a corporate mailroom—it takes outbound requests from internal employees, stamps them with the company's single public return address, and securely routes the replies back to the correct internal desk.

## Network Topology
*<img width="461" height="331" alt="Day4_topology" src="https://github.com/user-attachments/assets/99f51fc5-4193-4bf5-99ef-97639fd39c91" />*


---

## Technical Deep-Dive

### Technologies & Protocols Implemented
* **Device Security:** RSA Crypto Key Generation, SSHv2, Local User Authentication, VTY Line Lockdown.
* **External Connectivity:** Hardware Expansion (HWIC-2T Serial Module), Default Static Routing.
* **Address Translation:** NAT Overload / Port Address Translation (PAT).
* **Dynamic Routing Integration:** OSPF Default Route Injection (`default-information originate`).

### Configuration Highlights

#### 1. SSH Management Lockdown (HQ Router)
Generated 2048-bit RSA keys and forced the VTY lines to only accept encrypted SSH connections authenticated against a local user database.
```
hostname HQ-Gateway
ip domain-name corporate.local
crypto key generate rsa
username admin privilege 15 secret [REDACTED]
line vty 0 4
 login local
 transport input ssh
```
2. NAT Overload Configuration (HQ Router)
Defined the inside/outside interfaces and applied a PAT rule using an Access Control List to identify valid internal subnets allowed to reach the internet.

```
access-list 1 permit 192.168.0.0 0.0.255.255
ip nat inside source list 1 interface Serial0/0/0 overload
```
3. OSPF Default Route Injection
Instead of manually configuring static default routes on downstream branch devices, I instructed the HQ router's OSPF process to dynamically advertise the internet route to the rest of the enterprise.

```
router ospf 1
 default-information originate
```
Verification & Troubleshooting
Hardware Limitations Overcome: During implementation, the HQ 1941 router lacked sufficient physical Gigabit interfaces for the ISP connection.
I powered down the simulated device, installed an HWIC-2T expansion module, and brought the Serial WAN link up using DCE clocking to establish the connection.

Security Verification: Successfully logged into the HQ-Gateway from a Sales VLAN PC using SSH, confirming the deprecation of Telnet. <img width="224" height="92" alt="ssh_login" src="https://github.com/user-attachments/assets/8f68e3d5-d7c8-4382-b5ea-afbbcc157af1" />


Dynamic Routing Verification: Checked the Branch router's routing table to confirm the default route (O*E2 0.0.0.0/0) was successfully injected via OSPF. <img width="428" height="287" alt="ospf_default_route" src="https://github.com/user-attachments/assets/2efd14b4-137c-432b-a30f-15fb9762822d" />


Translation & Connectivity Verification: Successfully sent ICMP traffic from both the HQ and Branch PCs to an external 8.8.8.8 server.
Executed show ip nat translations on the HQ router to verify the private source IPs were successfully multiplexed onto the public 203.0.113.2 interface using unique port numbers.
<img width="432" height="127" alt="nat_translations" src="https://github.com/user-attachments/assets/f22f6a0d-9cb7-41ef-821d-60935368d852" /> <img width="437" height="182" alt="hq_ping" src="https://github.com/user-attachments/assets/d1384015-a1c1-465e-b570-cd53be0c2691" /> <img width="420" height="178" alt="Branch_ping" src="https://github.com/user-attachments/assets/83788d30-f17e-4281-8484-fb27fd63c762" />



