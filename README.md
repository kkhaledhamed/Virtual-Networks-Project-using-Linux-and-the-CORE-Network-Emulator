# Virtual-Networks-Project-using-Linux-and-the-CORE-Network-Emulator

## 📘 Project Description

This project explores the behavior and performance of TCP under various network configurations. By utilizing tools such as **iperf3**, **Wireshark**, and **OSPF routing simulations**, we:
- Measured throughput and retransmissions over different TCP window sizes.
- Analyzed TCP segments and ACK behavior.
- Compared short and long path routing in TCP.
- Investigated the effect of varying link capacities and packet loss.
- Simulated dynamic OSPF routing changes and database updates.

---

## 🧪 1. Effect of TCP Window Size

We tested TCP throughput and retransmissions for window sizes:  
`1K, 2K, 3K, 4K, 5K, 6K, 12K, 16K, 24K, 32K`.

For each configuration:
- **Throughput** = `(Transfers × Size × 8) / (Interval Time × 10^6)`  
- **Tool Used**: `iperf3`  
- **Packet Loss**: Measured via retransmission count.

| Window Size | Throughput (Mbps) | Retransmissions |
|-------------|-------------------|-----------------|
| 1K          | 1.88              | 0               |
| 2K          | 2.53              | 0               |
| 3K          | 4.78              | 0               |
| 4K          | 4.32              | 0               |
| 5K          | 4.23              | 1               |
| 6K          | 0.12              | 348             |
| 12K         | 1.37              | 1222            |
| 16K         | 0.31              | 429             |
| 24K         | 0.16              | 317             |
| 32K         | 0.16              | 384             |

### 💡 Insight:
- **Small window sizes (1K–4K)**: High throughput, 0 retransmissions.
- **Larger windows (6K–32K)**: Drastic performance drop due to receiver congestion.
- **Conclusion**: There’s a **Zig-Zag pattern**; optimal window size must balance speed and congestion control.

---

## 🔍 2. TCP Segment Analysis

### 2.I – Data Segment from Node n7
- Total frame length: **72 bytes**
- TCP + IP headers: **52 bytes**
- Data size: **4 bytes**
- Ethernet header: **16 bytes**

### 2.II – ACK Segment from Node n11
- Total frame length: **68 bytes**
- TCP + IP headers: **52 bytes**
- Ethernet header: **16 bytes**

---

## 🔁 3. TCP Short vs Long Paths

Compared two scenarios:
- **Short Path**: n7 (client) → n11 (server) = **3.57 Mbps**
- **Long Path**: n7 (client) → n8 (server) = **2.82 Mbps**

### 📝 Conclusion:
- Long paths have **higher latency** → **reduced throughput**.
- Distance in hops and RTT impact TCP performance.

---

## 🚦 4. Link Capacity vs Reliability

### Test Configurations:
| Case | Link Configuration                          | Throughput (Mbps) |
|------|----------------------------------------------|-------------------|
| A    | 10 Mbps, 0% loss                             | 3.77              |
| B    | 3 Mbps, 0% loss                              | 1.78              |
| C    | 10 Mbps, 5% loss                             | 0.34              |
| D    | 100 Mbps, 10% loss                           | 0.27              |
| E    | 10 Mbps, 1% loss (n4 → n5), 0% other way     | 2.62              |
| F    | 10 Mbps, 0% loss (n4 → n5), 1% other way     | 2.04              |

### 🔍 Insights:
- **B > C**: Although C has more capacity, the loss rate kills performance.
- **E > F**: Loss in **uplink** (data) affects throughput more than downlink (ACKs).
- **Conclusion**: **Low loss > High capacity** when it comes to TCP throughput.

---

## 📡 5. OSPF Link Cost Behavior

### 5.I – n7 to n11 Path Change
- Initial path: shortest path chosen when all link costs are equal.
- After setting `n5 → n4` cost = 40, routing changes to:  
  `n5 → n6 → n4` (total cost = 20)

### 5.II – Bidirectional Path Asymmetry
- n7 to n11 remains the same.
- n11 to n7 switches to a new lower-cost path:
  - From: `n9 → n4 → n5` (cost = 50)  
  - To: `n9 → n10 → n6 → n5` (cost = 30)

### ✅ Conclusion:
- OSPF routing may become **asymmetric** when link costs are not uniform.

---

## 🧠 6. OSPF Database and Routing Updates

### 6.I – Router n2's Database
- Shows link-state information including **age** and **link counts**.
- Routing tables reflect **equal cost paths**, except where link cost differs.

### 6.II – Routing Convergence Time
- When `n2 eth1` cost changed to 20:
  - Update seen in Wireshark
  - Total convergence time: **0.954 seconds**

### 6.III – Node Disconnection
- Disconnecting router n4:
  - Link count to `10.0.3.1` dropped from 3 to 1.
  - Cost to reach `10.0.3.0` increased from 30 to 40.
  - 
## 📊 7. MATLAB Visualization

We used MATLAB to visualize the relationship between **TCP window size**, **throughput**, and **retransmissions**.

### 📈 MATLAB Code

```matlab
% Data from your experiments
window_sizes = [1, 2, 3, 4, 5, 6, 12, 16, 24, 32]; % in KB
throughput = [1.8811, 2.532, 4.7815, 4.3201, 4.236, 0.1196, 1.3701, 0.312475, 0.166702, 0.160768]; % in Mbits/s
retransmissions = [0, 0, 0, 0, 1, 348, 1222, 429, 317, 384]; 

% Create figure with two subplots
figure;

% Plot Throughput vs Window Size
plot(window_sizes, throughput, '-o', 'LineWidth', 2, 'MarkerSize', 8);
title('Throughput vs Window Size');
xlabel('Window Size (KB)');
ylabel('Throughput (Mbits/s)');
grid on;

% Plot Retransmissions vs Window Size
figure
plot(window_sizes, retransmissions, '-o', 'LineWidth', 2, 'MarkerSize', 8, 'Color', [0.85 0.33 0.10]);
title('Average Retransmissions vs Window Size');
xlabel('Window Size (KB)');
ylabel('Number of Retransmissions');
grid on;

% Adjust layout
set(gcf, 'Position', [100 100 800 600]);

% Alternative: Single plot with two y-axes
figure;
yyaxis left;
plot(window_sizes, throughput, '-o', 'LineWidth', 2);
ylabel('Throughput (Mbits/s)');
ylim([0 max(throughput)*1.1]);

yyaxis right;
plot(window_sizes, retransmissions, '-s', 'LineWidth', 2);
ylabel('Number of Retransmissions');
ylim([0 max(retransmissions)*1.1]);

title('Network Performance vs Window Size');
xlabel('Window Size (KB)');
legend('Throughput', 'Retransmissions');
grid on;
set(gcf, 'Position', [100 100 900 500]);
```
---

## 📈 Graphs and Figures

- Throughput vs Window Size
- Average Retransmissions vs Window Size
- TCP Segment and ACK Snapshots
- OSPF Path Diagrams
- Routing Tables and Databases

(All graphs and screenshots included in the full `Report.pdf`)

---

## 📂 Files in Repository

- `Report.pdf` – Full detailed analysis and screenshots.
- `README.md` – Summary and documentation of findings.

---

## 📌 Conclusion

This project highlighted:
- TCP's sensitivity to window size and network reliability.
- Importance of selecting optimal TCP parameters.
- How routing protocol behavior (like OSPF) adjusts based on dynamic link states.
- Reliable, low-capacity links often outperform unreliable high-speed ones.
- Dynamic, asymmetric routing paths exist in real networks due to link cost adjustments.

---

## 🛠 Tools Used
- **iperf3**
- **Wireshark**
- **Mininet/NS3**
- **Linux Networking Tools**
- **Matlab**

