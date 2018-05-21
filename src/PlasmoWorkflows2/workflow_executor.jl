###########################
#Serial executor just schedules tasks in the priority queue
###########################
mutable struct SerialExecutor <: AbstractExecutor
    visits::Dict{AbstractDispatchNode,Int}  #number of times each node has been computed
    final_time::Number
end
SerialExecutor() = SerialExecutor(Dict{AbstractDispatchNode,Int}(),0)
SerialExecutor(time) = SerialExecutor(Dict{AbstractDispatchNode,Int}(),time)

#This is the main execution method for an executor
function execute!(workflow::Workflow,executor::AbstractExecutor)  #this should be on the graph really
    # nodes = collectnodes(workflow)                           #get all the nodes
    # executor.visits = Dict(zip(nodes,zeros(length(nodes))))  #set up a map of each node to how many times it has been visited
    initialize(workflow)
    execute!(workflow.coordinator,executor)
end

#run the next item in the schedule
#pop the next item off the queue and add it to Julia's scheduler to run it
function step(workflow::Workflow,executor::AbstractExecutor)
    step(workflow.coordinator,executor)
end

function run!(executor::SerialExecutor,workflow::Workflow,signal_event::AbstractEvent)
    #task = @schedule call!(workflow,event)
    task = run!(workflow.coordinator,signal_event)
    return task
end
