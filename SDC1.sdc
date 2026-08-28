# 1. Define the Primary Clock (e.g., 50 MHz -> Period = 20ns)
create_clock -name {CLK} -period 20.000 [get_ports {CLK}]

# 2. Automatically derive clock uncertainty (jitter, guardband)
derive_clock_uncertainty

# 3. Constrain Inputs (Setup/Hold timing relative to CLK)
# Assuming external inputs arrive within 2ns to 4ns after clock edge
set_input_delay -clock {CLK} -max 4.000 [get_ports {P_INPUT[*] V_INPUT P_EN P_BIT RST}]
set_input_delay -clock {CLK} -min 2.000 [get_ports {P_INPUT[*] V_INPUT P_EN P_BIT RST}]

# 4. Constrain Outputs (Setup/Hold requirements of receiving chip)
# Assuming external receiver requires 2ns setup time
set_output_delay -clock {CLK} -max 3.000 [get_ports {TX_OUTPUT BUSY}]
set_output_delay -clock {CLK} -min 0.500 [get_ports {TX_OUTPUT BUSY}]

# 5. Optional: Cut timing on Asynchronous Reset if handled asynchronously in design
set_false_path -from [get_ports {RST}] -to *