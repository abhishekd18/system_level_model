model TrialSystem
  replaceable package Medium = Modelica.Media.Air.SimpleAir constrainedby Modelica.Media.Interfaces.PartialMedium;
  //replaceable package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater
  //  constrainedby Modelica.Media.Interfaces.PartialMedium;
  Modelica.Fluid.Pipes.StaticPipe UV_in( redeclare package Medium = Medium,allowFlowReversal = true, diameter = 0.02, height_ab = 0, length = 0.2) annotation(
    Placement(visible = true, transformation(origin = {-82, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Pipes.StaticPipe UV_out(
      
    redeclare package Medium = Medium,allowFlowReversal=true,
    diameter= 0.02,
    height_ab= 0,
    length= 0.2) annotation(
    Placement(visible = true, transformation(origin = {52, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium = Medium, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {108, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  inner Modelica.Fluid.System system(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation(
    Placement(visible = true, transformation(origin = {-76, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Vessels.ClosedVolume Helmet(redeclare package Medium = Medium, V = 5e-3,nPorts = 3, p_start = 101325, use_portsData = false)  annotation(
    Placement(visible = true, transformation(origin = {-16, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Sources.MassFlowSource_T lungs(redeclare package Medium = Medium,m_flow = 0.0006, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-16, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Fluid.Sources.MassFlowSource_T Inlet(redeclare package Medium = Medium, m_flow = 0.000333, nPorts = 1)  annotation(
    Placement(visible = true, transformation(origin = {-140, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable BreathingProfile(fileName = "/home/openmodelica/Documents/mass_flow_rate.txt", tableName = "massflow", tableOnFile = true, verboseRead = true)  annotation(
    Placement(visible = true, transformation(origin = {-78, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(UV_out.port_b, boundary1.ports[1]) annotation(
    Line(points = {{62, 26}, {98, 26}}, color = {0, 127, 255}));
  connect(UV_out.port_a, Helmet.ports[1]) annotation(
    Line(points = {{42, 26}, {-16, 26}}, color = {0, 127, 255}));
  connect(UV_in.port_b, Helmet.ports[2]) annotation(
    Line(points = {{-72, 26}, {-16, 26}}, color = {0, 127, 255}));
  connect(lungs.ports[1], Helmet.ports[3]) annotation(
    Line(points = {{-16, -44}, {-16, 26}}, color = {0, 127, 255}));
  connect(Inlet.ports[1], UV_in.port_a) annotation(
    Line(points = {{-130, 26}, {-92, 26}, {-92, 26}, {-92, 26}}, color = {0, 127, 255}));
  connect(BreathingProfile.y[1], lungs.m_flow_in) annotation(
    Line(points = {{-66, -70}, {-26, -70}, {-26, -64}, {-24, -64}}, color = {0, 0, 127}));
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
    experiment(StopTime = 2000, Interval = 0.4, Tolerance = 1e-006),
    uses(Modelica(version = "3.2.3")));
end TrialSystem;