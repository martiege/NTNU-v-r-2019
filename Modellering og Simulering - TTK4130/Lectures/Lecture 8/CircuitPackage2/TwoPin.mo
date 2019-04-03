within CircuitPackage2;
partial model TwoPin "Some decumentation"
  Pin pin annotation (Placement(transformation(extent={{-100,-8},{-80,12}}),
        iconTransformation(extent={{-100,-8},{-78,8}})));
  Pout pout annotation (Placement(transformation(extent={{80,-6},{100,14}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

        Modelica.SIunits.Voltage v;
        Modelica.SIunits.Current i;

equation
  v = pin.v - pout.v;
  0 = pin.i + pout.i;
  i = pin.i;
end TwoPin;
