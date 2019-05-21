import numpy as np
import matplotlib.pyplot as plt

plt.style.use('ggplot')

# Create numpy arrays from the txt files
with open('x.txt') as f:
    x = np.array([float(num) for num in f.read().split()])

with open('t.txt') as f:
    t = np.array([float(num) for num in f.read().split()])


# Generate observation matrix H
H_matrix = np.array([[1, time, np.sin(2 * np.pi * time)] for time in t])

# Matrix operations
H_T = np.transpose(H_matrix)
H_T_H = np.matmul(H_T, H_matrix)
H_T_H_inv = np.linalg.inv(H_T_H)

theta_est = np.matmul(np.matmul(H_T_H_inv, H_T), np.transpose(x))


def estimator(time):
    return theta_est[0] + theta_est[1] * time + \
        theta_est[2] * np.sin(2 * np.pi * time)


# Generate estimates for each time step
x_est = np.array([estimator(time) for time in t])

print("Covariance matrix:")
print(H_T_H_inv)

plt.plot(t, x)
plt.plot(t, x_est)
plt.legend(['Observed signal', 'Estimate'])
plt.show()
