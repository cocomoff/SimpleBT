module SimpleBT

mutable struct Player{T}
    score::T
end

mutable struct Game{T}
    players::Array{Player{T}}
    N::Int
    n::Array{Int, 2}
    x::Array{Int, 2}
    T::Array{Int, 1}
end

Game(N::Int; value=1.0) = Game(
    [Player(value) for _ in 1:N],
    N,
    zeros(Int, N, N),
    zeros(Int, N, N),
    zeros(Int, N)
)

function update!(game::Game)
    # using `x`, `n`, and `T`, update players' scores
    
    πs = [p.score for p in game.players]
    πnew = zeros(Float64, game.N)

    for i in 1:game.N
        sum = 0.0
        for j in 1:game.N
            (i == j) && continue
            sum += 1 / (πs[i] + πs[j]) * game.n[i, j]
        end
        πnew[i] = game.T[i] / sum
    end

    for i in 1:game.N
        game.players[i].score = πnew[i] * game.N / sum(πnew)
    end
end



function prob(p1::Player, p2::Player)::Float64 
    p1.score / (p1.score + p2.score)
end


export Player,
       Game,
       prob,
       update!


end