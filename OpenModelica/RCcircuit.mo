model RCcircuit

  type Voltage=Real(unit="V");
  type Current=Real(unit="A");
  type Resistance=Real(unit="Ohm");
  type Capacitance=Real(unit="C");
  
  parameter Voltage Vb = 1 "Battery voltage";
  parameter Resistance R = 150;
  parameter Capacitance C = 2e-3;
  
  Current i;
  Voltage V_R;
  Voltage V_C;
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(period = 3, width = 33) annotation(
    Placement(visible = true, transformation(extent = {{-84, -4}, {-64, 16}}, rotation = 0)));
equation
  i = V_R/R;
  booleanPulse.y*Vb = V_R + V_C;
  C*der(V_C) = i;
annotation(
    uses(Modelica(version = "3.2.3")));
end RCcircuit;