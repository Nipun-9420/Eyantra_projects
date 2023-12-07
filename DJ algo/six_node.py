 #      0  1  2  3  4  5
 #      A  B  C  D  E  F
graph=[[0, 4, 4, 0, 0, 0], #A 0
       [4, 0, 2, 0, 0, 0], #B 1
       [4, 2, 0, 3, 1, 6], #C 2
       [0, 0, 3, 0, 0, 2], #D 3
       [0, 0, 1, 0, 0, 3], #E 4
       [0, 0, 6, 2, 3, 0]] #F 5
#---------------------------------------*graph end*
start_node= 0#------------------------------*Starting_node
end_node = 3#---------------------------------*ending_node
end_node_F = 3#---------------------------------*ending_node
distance_from_A =[0,99,99,99,99,99] # ------------------*Distance from a to a is zero and other is infinity
visited=[0,0,0,0,0,0]
previous_node =[0,0,0,0,0,0]
temp_visit =[0,0,0,0,0,0]
min_dist =100
min
array_L = 6
path=[0,0,0,0,0,0]
Result_path=[0,0,0,0,0,0,0]
l_v=1
reach=0
#Djistra start 
print("Start")
for i in range(array_L): #--------------------------*main Loop
        #--------------------------------------*A
        min_dist =100
        temp_visit =[0,0,0,0,0,0]
        for check in range(array_L):
                #
                for a in range(array_L):
                        if (distance_from_A[a]<min_dist) and (visited[a] == 0) and temp_visit[a]==0:
                                min =a
                                min_dist =distance_from_A[a]
                #print(min,"have min dist from starting ")   
                #---------------------**-------------------*B
                for b in range(array_L):
                        if (graph[min][b]!=0) and (visited[b]==0):
                                #print(b,"is unvisited from current vertex",min)
                                #-----------------------------------------*C D
                                #print("min distance of",b,"from",start_node,"is",graph[min][b])
                                if graph[min][b]+min_dist < distance_from_A[b]:
                                        distance_from_A[b] =graph[min][b]+min_dist
                                        #---------------------*E
                                        previous_node[b] = min
                temp_visit[a]==1
        #print("min_dist",min_dist)
        visited[i]=1
        #print("visited",visited)
       # print("--------------------")
print["distance_from_A",distance_from_A]   
print("previous_node",previous_node)           
for last in range(array_L):
        if last == 0:
                path[last]=end_node
        else:
                path[last]=previous_node[end_node]
                end_node = path[last]
print("path",path)
for last_path in range(array_L):
        main=array_L-last_path-1
        Result_path[0]=start_node
        if path[main]!=0:
                l_v
                Result_path[l_v]=path[main]
                l_v=l_v+1                
print("Result_path",Result_path)

#------Final path decision making code
desion =0
for desion in range(array_L):
        if Result_path[desion]== end_node_F:
                print("you are you position")
                reach =1
        elif reach==0:
                #print("desion",desion)    
                if Result_path[desion]==start_node:
                        if Result_path[desion+1] ==1:
                                print("Right")
                        elif Result_path[desion+1] ==2:
                                print("left") 
                        else:
                                print("No desion to take")
                #--------------0
                elif Result_path[desion]==0 and Result_path[desion-1]==1 and Result_path[desion+1]==2:
                        print("right")
                elif Result_path[desion]==0 and Result_path[desion-1]==2 and Result_path[desion+1]==1:
                        print("left")
                #--------------1                    
                elif Result_path[desion]==1 and Result_path[desion-1]==0 and Result_path[desion+1]==2:
                        print("left")      
                elif Result_path[desion]==1 and Result_path[desion-1]==2 and Result_path[desion+1]==0:
                        print("right")
                #---------------2
                elif Result_path[desion]==2 and (Result_path[desion-1]==1 or Result_path[desion-1]==0) and Result_path[desion+1]==3:
                        print("left")
                elif Result_path[desion]==2 and (Result_path[desion-1]==1 or Result_path[desion-1]==0) and Result_path[desion+1]==5:
                        print("Stright")
                elif Result_path[desion]==2 and (Result_path[desion-1]==1 or Result_path[desion-1]==0) and Result_path[desion+1]==4:
                        print("Right")
                elif Result_path[desion]==2 and (Result_path[desion-1]==3 or Result_path[desion-1]==5 or Result_path[desion-1]==4) and Result_path[desion+1]==1:
                        print("left")
                elif Result_path[desion]==2 and (Result_path[desion-1]==3 or Result_path[desion-1]==5 or Result_path[desion-1]==4) and Result_path[desion+1]==0:
                        print("right")
                #----------------3
                elif Result_path[desion]==3 and Result_path[desion-1]==2 and Result_path[desion+1]==5:
                        print("right")
                elif Result_path[desion]==3 and Result_path[desion-1]==5 and Result_path[desion+1]==2:
                        print("left")
                #---------------4
                elif Result_path[desion]==4 and Result_path[desion-1]==2 and Result_path[desion+1]==5:
                        print("left")
                elif Result_path[desion]==4 and Result_path[desion-1]==5 and Result_path[desion+1]==2:
                        print("right")
                else:
                        print("oooooooooooooooo")
