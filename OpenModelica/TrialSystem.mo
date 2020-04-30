model TrialSystem
  parameter Real HelmetVol = 5 "Helmet volume in Liters";
  parameter Real Volin = 30.0 "Volume flow rate in L/min";
  parameter Real MassFlow = 1.205 * Volin * 1.66667e-5;
  Real P_diff;
  replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
  //  constrainedby Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Pipes.StaticPipe UV_in(redeclare package Medium = Medium, allowFlowReversal = true, diameter = 0.02, height_ab = 0, length = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-82, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe UV_out(redeclare package Medium = Medium, allowFlowReversal = true, diameter = 0.02, height_ab = 0, length = 0.2) annotation(
    Placement(visible = true, transformation(origin = {52, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = Medium, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {108, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Fluid.System system(energyDynamics = Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(visible = true, transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume Helmet(redeclare package Medium = Medium, V = HelmetVol*1e-3, nPorts = 3, p_start = 101325, use_portsData = false) annotation(
    Placement(visible = true, transformation(origin = {-16, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T Inlet(redeclare package Medium = Medium, m_flow = MassFlow, nPorts = 1) annotation(
    Placement(visible = true, transformation(origin = {-140, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Lung model adapted from ventilation model by I Mas
  LungModel lungModel annotation(
    Placement(visible = true, transformation(origin = {-14, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe trachea(redeclare package Medium = Medium, diameter = 0.02, length = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-14, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation
  P_diff = (Helmet.ports[3].p - boundary1.p) * 100.0;
  connect(UV_out.port_b, boundary1.ports[1]) annotation(
    Line(points = {{62, 26}, {98, 26}}, color = {0, 127, 255}));
  connect(UV_out.port_a, Helmet.ports[1]) annotation(
    Line(points = {{42, 26}, {-16, 26}}, color = {0, 127, 255}));
  connect(UV_in.port_b, Helmet.ports[2]) annotation(
    Line(points = {{-72, 26}, {-16, 26}}, color = {0, 127, 255}));
  connect(Inlet.ports[1], UV_in.port_a) annotation(
    Line(points = {{-130, 26}, {-92, 26}, {-92, 26}, {-92, 26}}, color = {0, 127, 255}));
  connect(lungModel.port_b, trachea.port_a) annotation(
    Line(points = {{-14, -60}, {-14, -60}, {-14, -22}, {-14, -22}}, color = {0, 127, 255}));
  connect(trachea.port_b, Helmet.ports[3]) annotation(
    Line(points = {{-14, -2}, {-16, -2}, {-16, 26}, {-16, 26}}, color = {0, 127, 255}));
  annotation(
    Documentation(info = "<html>
<p>
Water is pumped from a source by a pump (fitted with check valves), through a pipe whose outlet is 50 m higher than the source, into a reservoir. The users are represented by an equivalent valve, connected to the reservoir.
</p>
<p>
The water controller is a simple on-off controller, regulating on the gauge pressure measured at the base of the tower; the output of the controller is the rotational speed of the pump, which is represented by the output of a first-order system. A small but nonzero rotational speed is used to represent the standby state of the pumps, in order to avoid singularities in the flow characteristic.
</p>
<p>
Simulate for 2000 s. When the valve is opened at time t=200, the pump starts turning on and off to keep the reservoir level around 2 meters, which roughly corresponds to a gauge pressure of 200 mbar.
</p>

<img src=\"modelica://Modelica/Resources/Images/Fluid/Examples/PumpingSystem.png\" border=\"1\"
     alt=\"PumpingSystem.png\">
</html>", revisions = "<html>
<ul>
<li><em>Jan 2009</em>
    by R&uuml;diger Franke:<br>
       Reduce diameters of pipe and reservoir ports; use separate port for measurement of reservoirPressure, avoiding disturbances due to pressure losses.</li>
<li><em>1 Oct 2007</em>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Parameters updated.</li>
<li><em>2 Nov 2005</em>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br>
       Created.</li>
</ul>
</html>"),
    experiment(StopTime = 120, Interval = 0.024, Tolerance = 1e-6, StartTime = 0),
    uses(Modelica(version = "3.2.3")),
  __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian,newInst",
  __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl"));
end TrialSystem;