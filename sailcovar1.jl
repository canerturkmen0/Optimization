using JuMP, Clp, Printf

d = [60 75 25 36]                   # demand for each quarter

m = Model(with_optimizer(Clp.Optimizer))

@variable(m, 0 <= x[1:4] <= 40)       # regularly produced
@variable(m, y[1:4] >= 0)             # overtime produced
@variable(m, h[1:5] >= 0)             # extra in stock
@constraint(m, h[1] == 15)
@constraint(m, h[5] >= 10)
@constraint(m, flow[i in 1:4], h[i]+x[i]+y[i]-(d[i])==h[i+1])
@objective(m, Min, 400*sum(x) + 450*sum(y) + 20*sum(h))
optimize!(m)

@printf("Regularly produced boats: %d %d %d %d\n", value(x[1]), value(x[2]), value(x[3]), value(x[4]))
@printf("Overtime produced boats: %d %d %d %d\n", value(y[1]), value(y[2]), value(y[3]), value(y[4]))
@printf("Extra boats in stock: %d %d %d %d %d\n", value(h[1]), value(h[2]), value(h[3]), value(h[4]), value(h[5]))
@printf("Optimized cost: %f\n", objective_value(m))
