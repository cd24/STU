# Define Entity Model
Tracking ID: [STU-3](https://mcavey.myjetbrains.com/youtrack/issue/STU-3)

## Overview

This proposal is about how to represent entities in the connected graph. These will represent claims, evidence, entities and anything else that ends up in the graph. They will be connected by edges representing the relationships between the entities.

## Background

This relates to how the graph itself will be represented in code. Thus it must be capable of working alongside the relationships shown through edges

## Technical Details

There are two levels to this, the first is the general representation of entities which allows us to put entities into the graph. This includes how the information relevant to the entities will be stored to how the edges it is connected to will be tracked. As such I propose the following model:

Entity:
    Name: String
    Description: String
    Notes: Array<String>
    Relationships: Array<edges> 
    
I will now go into the reasoning behind this model, starting with the Name and Description. These seemed really straightforward to be seeing as they are simply going to be used for the name of whatever entity we are working with and a short description provided by the user upon creation.

For notes I thought it would be beneficial to give an array as each note is distinct and may be unrelated. This will let the user add to the list and view the contents with ease as well as make it easier to access the notes as individuals should they need to be changed.

For the Relationships I saw two possible methods of storage. The first is that the edges would contain what they are connected to and the second was the nodes storing their edges. Personally I am inclined towards the nodes storing their edges as it is my understanding that we will often be traversing the graph starting at certain nodes (i.e. fetch all evidence that donald trump is a dick) and then finding all nodes which support that claim (as if we needed proof). Likely the edges will store their endpoints as well but by storing them here traversal becomes simpler for later functions.
    
Now that is just for a general entity so the better question is what about some specific entities. Should there be a difference between an entity such as a person and a claim. and if so what should the difference be? 

For a claim I would recomend the above with only two additions, the inclusion of a support category and a true category

Claim:
    True: Boolean
    Support: Double
Inherited from entity:
    Name: String
    Description: String
    Notes: Array<String>
    Relationships: Array<edges>
    
The True Boolean would be used to determine whether or not a given claim is true, how we use that could be dependant on what parameters we want or we could just let the user handle it. I had also considered implementing a system that allows for multiple levels of true, such as somewhat true and somewhat false, but I thought the notes would be capable of handling that nuance as someone could label it false and point out the true bits in the notes or label it true and put the false bits in the notes. I also would like to use the Support double for that as it is more flexible. I am enivsioning a system that computes how much your evidence supports a claim. This would be calculated by our system and could take into account trustibility of sources (which will be addressed later in this proposal). This may be getting ahead of myself but I wanted to have a value that could be used by the system to help illustrate how much the evidence put into the system supports a given claim. In a simple implementation it would simply be the number of sources that support the claim out of total sources represented as a percentage. in a more complicated representation it would be a value computed by an equation based on how much sources can be trusted and the accuracy of the articles included etc.

This next entity is not one we have previously discussed but one I very much want to include considering the purpose of this graph. It is sources. Sources are not the same as evidence, which we will get to next, but the are the groups who create evidence. For example, I might have Donald Trump as a source as he is a public figure with opinions and who makes claims, sometimes even claims that he could be an authority on. In addition we might see the washington post as a source and an entity as they might be the subject of controversy and a source of information. The important part is that with this we could allow people to define how trustworthy sources are which could allow for us to better represent the accuracy of a claim. After all its not just the number of people saying something, but the trustworthyness of the people saying it that matters. As such I propose the Following representation:

Source: 
    Trust: Integer
    Verify: Boolean
Inherited from entity:
    Name: String
    Description: String
    Notes: Array<String>
    Relationships: Array<edges>
    
The two new pieces are trust and verify. Trust being a number that is either computed or manually entered about the level of trust we should put into a source. For instance if we were to do a scale of 10, I would say breitbart is a 1 or a 2 and the CDC might be a 8 or a 9. This could be used to help rank claims later on in an equation we will need to design when we build more of the system.

Verify is a boolean and simply says whether or not the source needs to be verified. Simply put is a source has verify as true then when evidence from it is being applied to a claim, the system must find other evidence for that claim or it will ignore this source. It could be used for sources you might trust, but that are prone to tabloidism and as such you need a source without verify to... well, verify it. In essence when we use it as evidence it wont count unless we can find sources without the verify option to back it up.

TBD: Evidence, other

## Changes to existing API

Document any changes to API required.
