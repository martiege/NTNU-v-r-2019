within CircuitPackage2;
model Resistor1 "Standard Resistor "
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-84,38},{88,-32}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,26},{66,-20}},
          lineColor={238,46,47},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="standard")}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));

        extends TwoPin;

        parameter Modelica.SIunits.Resistance R=100 annotation(choices(choice=100 "standard",choice=50 "small",choice=150 "large"));

equation
  R*i=v;
end Resistor1;
