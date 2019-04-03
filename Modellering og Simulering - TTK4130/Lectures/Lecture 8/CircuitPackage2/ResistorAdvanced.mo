within CircuitPackage2;
model ResistorAdvanced "Standard Resistor "
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-82,44},{88,-44}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Text(
          extent={{-54,28},{60,-22}},
          lineColor={244,125,35},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="Advanced")}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)));

        extends TwoPin;

        parameter Modelica.SIunits.Resistance R=100 annotation(choices(choice=100 "X",choice=50 "XS",choice=150 "Xl"));
        parameter Modelica.SIunits.Temp_C T0=30;
        Modelica.SIunits.Temp_C T;

equation
  R*i=v;
  T0 = T;
end ResistorAdvanced;
