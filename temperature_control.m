% Load the FIS
fis = readfis('temperature_control.fis');

% Simulation parameters
time = 0:0.1:50; % Simulation time (seconds)
T_desired = 22;  % Desired temperature (°C)
T_current = 15;  % Initial temperature (°C)
T_rate = 0;      % Initial rate of temperature change

% Initialize outputs
P_heater = zeros(size(time)); % Heater power
P_fan = zeros(size(time));    % Fan power
T_history = zeros(size(time)); % Temperature history

% Run simulation
for i = 1:length(time)
    % Calculate error and rate of change of temperature
    error = T_desired - T_current;
    delta_error = T_rate;
    
    % Evaluate the FIS
    output = evalfis([error, delta_error], fis);
    P_heater(i) = output(1); % Heater power
    P_fan(i) = output(2);    % Fan power
    
    % Update temperature based on heater and fan power (simple model)
    T_rate = 0.1 * P_heater(i) - 0.1 * P_fan(i); % Rate of temperature change
    T_current = T_current + T_rate * 0.1; % Update current temperature
    T_history(i) = T_current; % Record temperature history
end

% Plot results
figure;
subplot(2, 1, 1);
plot(time, T_history, 'b', 'LineWidth', 2);
title('Temperature vs Time');
xlabel('Time (s)');
ylabel('Temperature (°C)');

subplot(2, 1, 2);
plot(time, P_heater, 'r', time, P_fan, 'g', 'LineWidth', 2);
title('Heater and Fan Power Levels vs Time');
xlabel('Time (s)');
ylabel('Power (%)');
legend('Heater Power', 'Fan Power');