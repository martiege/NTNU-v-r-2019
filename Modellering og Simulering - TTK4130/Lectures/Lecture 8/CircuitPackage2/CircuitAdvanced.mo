within CircuitPackage2;
model CircuitAdvanced
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

        extends Circuit(redeclare model ResistorModel=ResistorAdvanced(T0=10));
end CircuitAdvanced;
