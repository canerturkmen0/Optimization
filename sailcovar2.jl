using JuMP, Clp, Printf

d = [40 60 75 25]                      # demand for each quarter

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[0:4] <= 40)       # regularly produced
@variable(m, y[0:4] >= 0)             # overtime produced
@variable(m, h[1:5] >= 0)             # extra in stock
@variable(m, cplus[1:5] >= 0)
@variable(m, cminus[1:5] >= 0)
@constraint(m, x[0] == 40)
@constraint(m, y[0] == 10)
@constraint(m, h[1] == 10)
@constraint(m, h[5] >= 10)
@constraint(m, flow[i in 1:4], h[i]+x[i]+y[i]-d[i]==h[i+1])
@constraint(m, flow2[i in 0:3], x[i+1]+y[i+1]-(x[i]+y[i])==cplus[i+1]-cminus[i+1])
@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h) + 400*sum(cplus) + 500*sum(cminus))
optimize!(m)

@printf("Regularly produced boats: %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]))
@printf("Overtime produced boats: %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]))
@printf("Extra boats in stock: %d %d %d %d %d\n", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))
@printf("Cplus: %d %d %d %d %d\n", value(cplus[1]), value(cplus[2]), value(cplus[3]), value(cplus[4]), value(cplus[5]))
@printf("Cminus: %d %d %d %d %d\n", value(cminus[1]), value(cminus[2]), value(cminus[3]), value(cminus[4]), value(cminus[5]))
@printf("Optimized cost: %f\n", objective_value(m))
