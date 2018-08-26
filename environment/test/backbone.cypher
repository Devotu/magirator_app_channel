MATCH (n) DETACH DELETE n;

CREATE (id:GlobalUniqueId { count:1000 });

CREATE (n:User:Active { id:1 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Adam", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 1 CREATE (a)-[:Is]->(n:Player:Active { id:10 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"David" });

CREATE (n:User:Active { id:2 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Bertil", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 2 CREATE (a)-[:Is]->(n:Player:Active { id:11 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Erik" });

CREATE (n:User:Active { id:3 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Ceasar", password:"47b2686cbbc5aba83021072684c76602c4aef2aa22c5546987045817d10aef5a169ca7d77731cf334ae32c22bcaa8d6e57037e4456131cf1bbef9af30a08ace0" });
MATCH (a:User) WHERE a.id = 3 CREATE (a)-[:Is]->(n:Player:Active { id:12 }) -[:Currently]-> (d:Data { created:TIMESTAMP(), name:"Filip" });

MATCH (a:Player) WHERE a.id = 10 CREATE (a)-[:Possess]->(n:Deck:Active { id:20 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 1", format:"STANDARD", theme:"Testing", black:true, white:true, red:false, green:false, blue:false, colorless:false});
MATCH (a:Player) WHERE a.id = 10 CREATE (a)-[:Possess]->(n:Deck:Active { id:21 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 2", format:"PAUPER", theme:"Testing", black:true, white:true, red:true, green:true, blue:true, colorless:true});
MATCH (a:Player) WHERE a.id = 11 CREATE (a)-[:Possess]->(n:Deck:Active { id:22 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 3", format:"BOOSTER_HANDOVER", theme:"Testing", black:false, white:false, red:false, green:false, blue:false, colorless:false});
MATCH (a:Player) WHERE a.id = 12 CREATE (a)-[:Possess]->(n:Deck:Active { id:23 })-[:Currently]->(d:Data {created:TIMESTAMP(), name:"Deck 4", format:"MODERN", theme:"Testing", black:false, white:false, red:true, green:false, blue:false, colorless:false});

MATCH (a:Player) WHERE a.id = 11 CREATE (a)-[:Created]->(g:Game { id:40, created:TIMESTAMP(), end:"VICTORY" });
MATCH (d:Deck), (g:Game) WHERE d.id = 20 AND g.id = 40 CREATE (d)-[:Got]->(r:Result { id:30, created:TIMESTAMP(), place:1, comment:"First result" })-[:In]->(g);
MATCH (d:Deck), (g:Game) WHERE d.id = 22 AND g.id = 40 CREATE (d)-[:Got]->(r:Result { id:31, created:TIMESTAMP(), place:2, comment:"Second result" })-[:In]->(g);

MATCH (a:Player) WHERE a.id = 12 CREATE (a)-[:Created]->(g:Game { id:41, created:TIMESTAMP(), end:"VICTORY" });
MATCH (d:Deck), (g:Game) WHERE d.id = 20 AND g.id = 41 CREATE (d)-[:Got]->(r:Result { id:32, created:TIMESTAMP(), place:1, comment:"Third result" })-[:In]->(g);
MATCH (d:Deck), (g:Game) WHERE d.id = 23 AND g.id = 41 CREATE (d)-[:Got]->(r:Result { id:33, created:TIMESTAMP(), place:2, comment:"Fourth result" })-[:In]->(g);