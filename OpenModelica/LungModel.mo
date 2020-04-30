within ;
// Adapted from ventilation model by I Mas
model LungModel

  constant Real PA2MBAR=1/1e5*1e3 "Convert Pa to mbar";
  constant Real P_STANDARD_PA=101325 "Ambient pressure in Pa";
  parameter Real R=287    "Gas constant in J/kg K";
  parameter Real Comp=10*(1e-6/100) "Compliance in m3/Pa";
  parameter Real Vtidal = 0.5*0.1^3 "Tidal volume in m3";
  parameter Real Vresidual = 2.450*0.1^3 "Residual lung volume in m3";

  Real T(start=273.15+36) "Temperature of chamber in K";
  Real V(start=2.5*0.1^3) "Volume m3";
  Real p(start=P_STANDARD_PA)    "Pressure [Pa]";
  Real p_Lung_mbar;   // Over Ambient in mbar
  Real V_L "Volume in L";
  Real V_normal_volume;
  Real H "Total enthalpy";
  Real h "specific enthalpy";

  parameter Real Tin=273.15+20 "Temperature of inflowing air";
  Real p0;
  //(1+5)*1e5*0+105711.72 "Source pressure [Pa]";
  //parameter Real pHigh=105711.72;
  //parameter Real pLow=P_STANDARD_PA+5/PA2MBAR;

  parameter Real Rflow=1e6 "Flow resistance";
  parameter Real Cp=Cv+R  "Cp in J/kgK";
  parameter Real Cv=718   "Cv in J/kgK";


  Real m "Mass [kg]";
  Real Qdot_in;
  Real Qdot_in_av;
  Real Eheat_in;
  Real hin;

  RCcircuit volumePulse annotation(
    Placement(visible = true, transformation(origin = {-8,-34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Fluid.Interfaces.FluidPort_b port_b annotation(
    Placement(visible = true, transformation(origin = {-8, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-8, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  p0 = P_STANDARD_PA;
  p = port_b.p;
  hin = port_b.h_outflow;
  port_b.m_flow = der(m);
  port_b.h_outflow = der(h);

  //p0 = P_STANDARD_PA;
  //hin = Cp*Tin;
  //V = (Vmax/2)*sin(2*Modelica.Constants.pi/5*time) + Vmin;
  //V = if booleanPulse.y then Vmax*(1.0-exp(-(time*7.7)))+Vmin else Vmax*exp(7.7*(1.0-time))+Vmin;
  V = volumePulse.V_C*Vtidal+Vresidual;

  //der(m)*Rflow=(p0-p);
  //der(m)=V/(R*T)*(der(p)*(1+Comp*p/V)-p/T*der(T));

  //Cv*der(m)*T+Cv*m*der(T)=der(m)*hin+Qdot_in;
  der(H)=der(m)*hin+Qdot_in;
  T=273.15+36;
  //der(V)=Comp*der(p);
  //der(p) = der(V)/Comp;
  p*V = m*R*T;
  V_L=V/0.1^3;
  p_Lung_mbar=(p-P_STANDARD_PA)*PA2MBAR;
  h=Cp*T;
  H=Cp*m*T;
  der(Eheat_in)=Qdot_in;
  Qdot_in_av=if time<1 then 0 else Eheat_in/time;
  //Qdot_in_av= Eheat_in/time;
  // Flow in standard volume in L
  der(V_normal_volume)=der(m)*R*273.15/101325*1/0.1^3;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
      coordinateSystem(preserveAspectRatio=false)),
    uses(Modelica(version="3.2.2")));
end LungModel;