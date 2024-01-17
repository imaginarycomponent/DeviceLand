# Stack that supports any type.
stack<public>(t:type) := class<computes>:
    Items<public>:[]t = array{}
    
    Push<public>(Item:t)<computes>:stack(t)=
        stack(t){ Items := Items + array{Item} }
    
    Pop<public>()<decides><computes>:tuple(stack(t), t)=
        Ret:t = Items[Items.Length - 1]
        (stack(t){ Items := Items.RemoveElement[Items.Length - 1] }, Ret)

<# 
    # Use it like so:
    var MyStack:stack(creative_prop) = stack(creative_prop){}
    set MyStack = MyStack.Push(Prop)
    if (StackPop := MyStack.Pop[]):
        set MyStack = StackPop(0)
        Prop = StackPop(1) 

#>