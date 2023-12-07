 #      0  1  2  3  4  5  6  7  8  9  10 11 12
 #      A  B  C  D  E  F  G  H  I  J  K  L  M  
graph=[[0, 3, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], #A 0
       [3, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 4], #B 1
       [2, 0, 0, 1, 0, 0, 0, 0, 2, 0, 0, 0, 0], #C 2
       [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], #D 3
       [0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 3, 0, 0], #E 4
       [0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0], #F 5
       [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0], #G 6
       [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0], #H 7
       [0, 0, 2, 0, 0, 0, 0, 0, 0, 3, 0, 0, 0], #I 8
       [0, 0, 0, 0, 0, 0, 1, 0, 3, 0, 1, 0, 0], #J 9
       [0, 0, 0, 0, 3, 0, 0, 0, 0, 1, 0, 2, 0], #K 10
       [0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 2, 0, 1], #L 11
       [0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]] #M 12
#---*graph end*
start_node= 10#---*Starting_node
end_node = 0#------*ending_node
end_node_F = 0#--*ending_node for referance
distance_from_start =[0,99,99,99,99,99,99,99,99,99,99,99] # *Distance from a to a is zero and other is infinity
visited=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
previous_node =[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
temp_visit =[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]  #taking temp visited for one loop
small_dist =99
array_L = 12
path=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Result_path=[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
cost_from_start= [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
l_v=1
reach=0 # used when to take desion
min_i=0 #------------------to save min index
min_dist = 100 #-------------------------------------min distance 
#Djistra start 
print("Start")
for i in range(array_L):#--------------------------*main Loop
    #--------------------------------------*A
    for check in range(array_L):# for loop to check near distance from all neb
        for a in range(array_L):
            if ((graph[start_node][a]!=0) and (visited[a]==0)) : 
                distance_from_start[a]=graph[start_node][a]
        for b in range(array_L):
            min_dist = 100
            if min_dist>distance_from_start[b]:
                min_i=b
                min_dist = distance_from_start[min_i]
                previous_node[b] =min_i
        for c in range(array_L):
            if ((graph[min_i][c]!=0) and (visited[c]==0) and min_dist+graph[min_i][c]<distance_from_start[c]) :
                distance_from_start[c]=min_dist+graph[min_i][c]
                previous_node[c] =min_i 
    visited[a]=1
print("distance_from_start",distance_from_start)
print("previous_node",previous_node)
