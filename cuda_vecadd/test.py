import numpy as np
import change_element
import vecadd

np.set_printoptions(suppress=True)

a = np.array([10, 12, 300], dtype=np.double)
b = np.array([1, 2, 3], dtype=np.double)

# before and after test
print("before", b)
change_element.change_element(b)
print("after", b)

print("\n\n")

# before and after test
print("a = ", a)
print("b = ", b)
print("addition ", vecadd.vec_add(a,b))
