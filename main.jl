using Revise

include("src/simplebt.jl")

using Main.SimpleBT

using Plots
gr()

function main()
    # AとBが同じ強さ
    pA = Player(1.0)
    pB = Player(1.0)
    println(pA, " ", pB)
    println(prob(pA, pB))

    # Aが強くBが弱い
    pA = Player(10.)
    pB = Player(0.1)
    println(pA, " ", pB)
    println(prob(pA, pB))

    # N人ゲーム
    N = 3
    game = Game(N)
    game.n[1, 2] = game.n[2, 1] = 10
    game.n[1, 3] = game.n[3, 1] = 10
    game.n[2, 3] = game.n[3, 2] = 10
    
    dataX = [(1, 2, 7), (1, 3, 8), (2, 3, 5)]
    for (i, j, xij) in dataX
        game.x[i, j] = xij
        game.x[j, i] = game.n[i, j] - xij
    end

    for i in 1:N
        game.T[i] = sum(game.x[i, :])
    end
    
    println(game.x)
    K = 30
    traces = zeros(Float64, K, N)
    for k in 1:K
        traces[k, :] = [p.score for p in game.players]
        update!(game)
    end

    f = plot(size=(500, 300))
    for n in 1:N
        plot!(f, traces[:, n])
    end
    savefig(f, "trace.png")

end

main()
