#Define the parameters

struct solow
    alpha
    delta
    s
    a
    n
end

#simulate the model
#in the case that we have several model we should determine s::
# instead of writing long function, we should write it step by step
#for avoiding writing some code twice like what we did for out put we could define output function.

function output(s::solow,A,K,N)
    return A*K^s.alpha*N^(1-s.alpha)
end

# saving function
function saving(s::solow,K,Y)
    return s.s*Y
end
# we want to modefy saving function for another economy
# Another economy
struct solow_modified
    alpha
    delta
    sy
    a
    n
    sk
end
# modified saving function 
function saving(s::solow_modified,K,Y)
    return s.sy*Y + s.sk*K
end


# modify output function

struct solow_linearprod
    delta
    sy
    a
    n
    
end

# Third economy

function output(s::solow_linearprod,A,K,N)

    return A*K
end



function sim(s::solow,K0,A0,N0,T)
    K = zeros(T)
    A = zeros(T)
    N = zeros(T)
    Y = zeros(T)
    K[1] = K0
    A[1] = A0
    N[1] = N0
    Y[1] = A0*K0^s.alpha*N0^(1-s.alpha) #we could replace this line with Y[1] = output(s,A0,K0,N0)
    I = s.s*Y[1]
    for t=2:T
       K[t] = (1-s.delta)*K[t-1] + saving(s,K[t-1],Y[t-1]) #we could s.s*Y[t-1]
       A[t] = (1+s.a)*A[t-1] 
       N[t] = (1+s.n)*N[t-1]
       Y[t] = A[t]*K[t]^s.alpha*N[t]^(1-s.alpha)  #we could replace this line with Y[t] = output(s,A[t],K[t],N[t])
       I = s.s*Y[t]
    end
    return K,A,N,Y
end