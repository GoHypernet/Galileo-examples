import numpy as np

def fastLS(A: np.array, b: np.array, k: int) -> np.array:
    
    rows = A.shape[0]
    cols = A.shape[1]
    
    # first allocate the gaussian measurement matrix
    omega = np.random.normal(0,1,[k,rows])
    
    # then extract the dominant subspace
    Y = np.matmul(omega,A)
    Q = np.linalg.qr(Y.transpose())[0]
    
    # factorize the compressed system
    Ar = np.matmul(A,Q)
    Gr = np.matmul(Ar.transpose(),Ar)
    Sigma, Ur = np.linalg.eig(Gr)
    Sigma = np.sqrt(Sigma)
    
    # create the expanded operators
    U = np.matmul(Q,Ur)
    Vt = np.matmul(np.linalg.inv(np.diag(Sigma)),np.matmul(Ur.transpose(),Ar.transpose()))
    
    # solve the system
    x = np.matmul(U,np.matmul(np.linalg.inv(np.diag(Sigma)),np.matmul(Vt,b)))
    
    return x