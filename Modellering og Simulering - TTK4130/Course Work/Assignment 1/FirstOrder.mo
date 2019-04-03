model FirstOrder  "A linear 1. order diff. eq."
  // Parameters and variables
  parameter Real a = -3  "Growth rate";
  parameter Real b = 17  "Steady-state value";
  Real x(start= -2)  "State";
equation
  // The differential equation
  der(x) = a*x + b  "1. order diff. eq.";
end FirstOrder;