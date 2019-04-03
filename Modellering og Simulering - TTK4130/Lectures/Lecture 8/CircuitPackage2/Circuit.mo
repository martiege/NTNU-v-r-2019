within CircuitPackage2;
model Circuit
  ResistorModel resistorModel(R=100)
    annotation (Placement(transformation(extent={{-44,34},{-24,54}})));
  ResistorModel resistorModel1
    annotation (Placement(transformation(extent={{16,36},{36,56}})));
  Modelica.Electrical.Analog.Basic.Ground ground
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Electrical.Analog.Sources.ConstantVoltage constantVoltage
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-66,4})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

        replaceable model ResistorModel = Resistor1;
equation
  connect(constantVoltage.n, resistorModel.pin) annotation (Line(points={{-66,
          14},{-56,14},{-56,44},{-42.9,44}}, color={0,0,255}));
  connect(resistorModel.pout, resistorModel1.pin) annotation (Line(points={{-25,
          44.4},{-4.5,44.4},{-4.5,46},{17.1,46}}, color={28,108,200}));
  connect(resistorModel1.pout, ground.p) annotation (Line(points={{35,46.4},{48,
          46.4},{48,-10},{30,-10}}, color={28,108,200}));
  connect(ground.p, constantVoltage.p) annotation (Line(points={{30,-10},{-18,
          -10},{-18,-6},{-66,-6}}, color={0,0,255}));
end Circuit;
