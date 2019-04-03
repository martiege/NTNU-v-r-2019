within CircuitPackage2;
connector Pout "connector of electrical components "

        Modelica.SIunits.Voltage v; // identical at connection
        flow Modelica.SIunits.Current i; // sum-to-0 at connection
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,102},{100,-98}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid), Text(
          extent={{-56,30},{52,-40}},
          lineColor={255,255,255},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          textString="Pout
")}),                                                            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Pout;
