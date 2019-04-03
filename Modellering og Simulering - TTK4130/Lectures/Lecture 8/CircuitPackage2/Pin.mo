within CircuitPackage2;
connector Pin "connector of electrical components "

        Modelica.SIunits.Voltage v; // identical at connection
        flow Modelica.SIunits.Current i; // sum-to-0 at connection
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid), Text(
          extent={{-54,40},{54,-30}},
          lineColor={255,255,255},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="Pin")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Pin;
