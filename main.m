% Data from experiments
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
