clear

n = 0:20;

x = [1 zeros(1,20)];

y = filter ([-3,2],[1 -0.5],x);

stem(n,y,'filled');

y = filter ([-3,2],[1 -0.5],x)

stem(n,y,'filled')

B = [-3 2]
A = [-0.5]

iirfunction(B,A,x)




