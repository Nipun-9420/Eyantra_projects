var g_data = {"6":{"pr":"/tb_userinterface/BFM1/DUT1","t":"inst","br":[{"bs":[{"s":"   assign addbus_ram = ena1 ? addbus_proca : 12'b z;","f":3,"i":1,"l":65,"h":40},{"s":"   assign addbus_ram = ena1 ? addbus_proca : 12'b z;","t":43,"n":1,"f":3,"i":2,"l":65,"h":30}],"br":{"s":"   assign addbus_ram = ena1 ? addbus_proca : 12'b z;","f":3,"l":65,"i":1,"p":100.00}},{"bs":[{"s":"   assign addbus_ram = enb1 ? addbus_procb : 12'b z;","f":3,"i":1,"l":66,"h":35},{"s":"   assign addbus_ram = enb1 ? addbus_procb : 12'b z;","t":43,"n":1,"f":3,"i":2,"l":66,"h":30}],"br":{"s":"   assign addbus_ram = enb1 ? addbus_procb : 12'b z;","f":3,"l":66,"i":1,"p":100.00}},{"bs":[{"s":"   assign addbus_ram = enc1 ? addbus_procc : 12'b z;","f":3,"i":1,"l":67,"h":36},{"s":"   assign addbus_ram = enc1 ? addbus_procc : 12'b z;","t":43,"n":1,"f":3,"i":2,"l":67,"h":30}],"br":{"s":"   assign addbus_ram = enc1 ? addbus_procc : 12'b z;","f":3,"l":67,"i":1,"p":100.00}},{"bs":[{"s":"   assign datawritebus_ram = ena2 ? datawritebus_proca : 8'b z;","f":3,"i":1,"l":70,"h":40},{"s":"   assign datawritebus_ram = ena2 ? datawritebus_proca : 8'b z;","t":55,"n":1,"f":3,"i":2,"l":70,"h":32}],"br":{"s":"   assign datawritebus_ram = ena2 ? datawritebus_proca : 8'b z;","f":3,"l":70,"i":1,"p":100.00}},{"bs":[{"s":"   assign datawritebus_ram = enb2 ? datawritebus_procb : 8'b z;","f":3,"i":1,"l":71,"h":35},{"s":"   assign datawritebus_ram = enb2 ? datawritebus_procb : 8'b z;","t":55,"n":1,"f":3,"i":2,"l":71,"h":30}],"br":{"s":"   assign datawritebus_ram = enb2 ? datawritebus_procb : 8'b z;","f":3,"l":71,"i":1,"p":100.00}},{"bs":[{"s":"   assign datawritebus_ram = enc2 ? datawritebus_procc : 8'b z; ","f":3,"i":1,"l":72,"h":36},{"s":"   assign datawritebus_ram = enc2 ? datawritebus_procc : 8'b z; ","t":55,"n":1,"f":3,"i":2,"l":72,"h":30}],"br":{"s":"   assign datawritebus_ram = enc2 ? datawritebus_procc : 8'b z; ","f":3,"l":72,"i":1,"p":100.00}},{"bs":[{"s":"   assign r_wb_ram = ena2 ? r_wb_proca : 1'bz;","f":3,"i":1,"l":75,"h":40},{"s":"   assign r_wb_ram = ena2 ? r_wb_proca : 1'bz;","t":39,"n":1,"f":3,"i":2,"l":75,"h":30}],"br":{"s":"   assign r_wb_ram = ena2 ? r_wb_proca : 1'bz;","f":3,"l":75,"i":1,"p":100.00}},{"bs":[{"s":"   assign r_wb_ram = enb2 ? r_wb_procb : 1'bz;","f":3,"i":1,"l":76,"h":34},{"s":"   assign r_wb_ram = enb2 ? r_wb_procb : 1'bz;","t":39,"n":1,"f":3,"i":2,"l":76,"h":29}],"br":{"s":"   assign r_wb_ram = enb2 ? r_wb_procb : 1'bz;","f":3,"l":76,"i":1,"p":100.00}},{"bs":[{"s":"   assign r_wb_ram = enc2 ? r_wb_procc : 1'bz;","f":3,"i":1,"l":77,"h":36},{"s":"   assign r_wb_ram = enc2 ? r_wb_procc : 1'bz;","t":39,"n":1,"f":3,"i":2,"l":77,"h":29}],"br":{"s":"   assign r_wb_ram = enc2 ? r_wb_procc : 1'bz;","f":3,"l":77,"i":1,"p":100.00}},{"bs":[{"s":"         if(reset == 1)","f":3,"i":1,"l":82,"h":1},{"s":"         else if (en_timeout==1)","f":3,"i":1,"l":87,"h":1},{"s":"         else if(runtimer == 0)","f":3,"i":1,"l":89,"h":24},{"s":"         else","f":3,"i":1,"l":91,"h":79}],"br":{"s":"         if(reset == 1)","f":3,"l":82,"i":1,"p":100.00}},{"bs":[{"s":"         if(count == timeoutclockperiods)","f":3,"i":1,"l":98,"h":3},{"s":"         else","f":3,"i":1,"l":100,"h":82}],"br":{"s":"         if(count == timeoutclockperiods)","f":3,"l":98,"i":1,"p":100.00}},{"bs":[{"s":"         if(reset)","f":3,"i":1,"l":108,"h":2},{"s":"         else","f":3,"i":1,"l":110,"h":28}],"br":{"s":"         if(reset)","f":3,"l":108,"i":1,"p":100.00}},{"bs":[{"s":"            IDLE: if(reqa == 1)","f":3,"i":1,"l":122,"h":12},{"s":"            GRANT_A: if(reqa==1 && timesup==0)//processor A allowed continued access","f":3,"i":1,"l":138,"h":9},{"s":"            GRANT_B: if((reqb == 1)&&(timesup == 0))//processor B allowed continued access","f":3,"i":1,"l":151,"h":8},{"s":"            GRANT_C: if(reqc == 1 && timesup == 0)//processor c allowed continued access				","f":3,"i":1,"l":165,"h":9},{"s":"            default: nextstate = IDLE;","f":3,"i":1,"l":178,"h":2}],"br":{"s":"         case(currentstate)","f":3,"l":121,"i":1,"p":100.00}},{"bs":[{"s":"            IDLE: if(reqa == 1)","t":18,"n":2,"f":3,"i":2,"l":122,"h":2},{"s":"		  else if(reqb == 1)   ","f":3,"i":1,"l":127,"h":2},{"s":"		  else if(reqc == 1)","f":3,"i":1,"l":132,"h":1},{"s":"All False","f":3,"i":2,"l":122,"h":7}],"br":{"s":"            IDLE: if(reqa == 1)","f":3,"l":122,"i":2,"p":100.00}},{"bs":[{"s":"            GRANT_A: if(reqa==1 && timesup==0)//processor A allowed continued access","t":21,"n":2,"f":3,"i":2,"l":138,"h":5},{"s":"		     else if(reqb==1) ","f":3,"i":1,"l":144,"h":1},{"s":"   		     else if(reqc==1)","f":3,"i":1,"l":146,"h":2},{"s":"		     else","f":3,"i":1,"l":148,"h":1}],"br":{"s":"            GRANT_A: if(reqa==1 && timesup==0)//processor A allowed continued access","f":3,"l":138,"i":2,"p":100.00}},{"bs":[{"s":"            GRANT_B: if((reqb == 1)&&(timesup == 0))//processor B allowed continued access","t":21,"n":2,"f":3,"i":2,"l":151,"h":5},{"s":"		     else if(reqc == 1)","f":3,"i":1,"l":157,"h":1},{"s":"		     else if(reqa == 1)","f":3,"i":1,"l":159,"h":1},{"s":"		     else","f":3,"i":1,"l":161,"h":1}],"br":{"s":"            GRANT_B: if((reqb == 1)&&(timesup == 0))//processor B allowed continued access","f":3,"l":151,"i":2,"p":100.00}},{"bs":[{"s":"            GRANT_C: if(reqc == 1 && timesup == 0)//processor c allowed continued access				","t":21,"n":2,"f":3,"i":2,"l":165,"h":5},{"s":"		     else if(reqa == 1)","f":3,"i":1,"l":171,"h":1},{"s":"		     else if(reqb == 1)","f":3,"i":1,"l":173,"h":1},{"s":"		     else","f":3,"i":1,"l":175,"h":2}],"br":{"s":"            GRANT_C: if(reqc == 1 && timesup == 0)//processor c allowed continued access				","f":3,"l":165,"i":2,"p":100.00}},{"bs":[{"s":"         if(reset)	       ","f":3,"i":1,"l":185,"h":2},{"s":"         else","f":3,"i":1,"l":191,"h":101}],"br":{"s":"         if(reset)	       ","f":3,"l":185,"i":1,"p":100.00}},{"bs":[{"s":"                  GRANT_A:","f":3,"i":1,"l":197,"h":33},{"s":"		  GRANT_B:","f":3,"i":1,"l":201,"h":29},{"s":"                  GRANT_C:","f":3,"i":1,"l":205,"h":29},{"s":"                  default:","f":3,"i":1,"l":209,"h":10}],"br":{"s":"               case(nextstate)","f":3,"l":196,"i":1,"p":100.00}}]},"5":{"pr":"/tb_userinterface/BFM1","t":"inst","br":[{"bs":[{"s":"				if(addbus_ram !== 12'bz || ","f":2,"i":1,"l":131,"h":0},{"s":"All False","f":2,"i":1,"l":131,"h":1}],"br":{"s":"				if(addbus_ram !== 12'bz || ","f":2,"l":131,"i":1,"p":50.00}},{"bs":[{"s":"					NR : begin","f":2,"i":1,"l":178,"h":5},{"s":"					RA : begin","f":2,"i":1,"l":190,"h":3},{"s":"					RB : begin","f":2,"i":1,"l":202,"h":3},{"s":"					RC : begin","f":2,"i":1,"l":214,"h":3},{"s":"All False","f":2,"i":1,"l":177,"h":0}],"br":{"s":"				case(data)","f":2,"l":177,"i":1,"p":80.00}},{"bs":[{"s":"								if(addbus_ram !== 12'bz ||","f":2,"i":1,"l":179,"h":0},{"s":"All False","f":2,"i":1,"l":179,"h":5}],"br":{"s":"								if(addbus_ram !== 12'bz ||","f":2,"l":179,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_proca ||","f":2,"i":1,"l":191,"h":0},{"s":"All False","f":2,"i":1,"l":191,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_proca ||","f":2,"l":191,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_procb ||","f":2,"i":1,"l":203,"h":0},{"s":"All False","f":2,"i":1,"l":203,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_procb ||","f":2,"l":203,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_procc ||","f":2,"i":1,"l":215,"h":0},{"s":"All False","f":2,"i":1,"l":215,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_procc ||","f":2,"l":215,"i":1,"p":50.00}},{"bs":[{"s":"					RAB  : begin                ","f":2,"i":1,"l":280,"h":1},{"s":"					RBC  : begin                ","f":2,"i":1,"l":292,"h":1},{"s":"					RCA  : begin                ","f":2,"i":1,"l":304,"h":1},{"s":"All False","f":2,"i":1,"l":279,"h":0}],"br":{"s":"				case(data)","f":2,"l":279,"i":1,"p":75.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_procb ||","f":2,"i":1,"l":281,"h":0},{"s":"All False","f":2,"i":1,"l":281,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_procb ||","f":2,"l":281,"i":1,"p":50.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_procc ||","f":2,"i":1,"l":293,"h":0},{"s":"All False","f":2,"i":1,"l":293,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_procc ||","f":2,"l":293,"i":1,"p":50.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_proca ||","f":2,"i":1,"l":305,"h":0},{"s":"All False","f":2,"i":1,"l":305,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_proca ||","f":2,"l":305,"i":1,"p":50.00}},{"bs":[{"s":"			NOREQ    : begin","f":2,"i":1,"l":323,"h":1},{"s":"			REQFA    : begin","f":2,"i":1,"l":329,"h":1},{"s":"			REQFB    : begin","f":2,"i":1,"l":336,"h":1},{"s":"			REQFC    : begin","f":2,"i":1,"l":343,"h":2},{"s":"			SACC     : begin","f":2,"i":1,"l":350,"h":1},{"s":"			ATCAB    : begin","f":2,"i":1,"l":356,"h":1},{"s":"			ATCBC    : begin","f":2,"i":1,"l":363,"h":1},{"s":"			ATCCA    : begin","f":2,"i":1,"l":369,"h":1},{"s":"			REQFBA		: begin                                  ","f":2,"i":1,"l":375,"h":1},{"s":"			REQFCB		: begin                                 ","f":2,"i":1,"l":381,"h":1},{"s":"All False","f":2,"i":1,"l":322,"h":1}],"br":{"s":"			case(bfm_command)","f":2,"l":322,"i":1,"p":100.00}}]},"2":{"pr":"work.bfm_arbiter","t":"du","br":[{"bs":[{"s":"				if(addbus_ram !== 12'bz || ","f":2,"i":1,"l":131,"h":0},{"s":"All False","f":2,"i":1,"l":131,"h":1}],"br":{"s":"				if(addbus_ram !== 12'bz || ","f":2,"l":131,"i":1,"p":50.00}},{"bs":[{"s":"					NR : begin","f":2,"i":1,"l":178,"h":5},{"s":"					RA : begin","f":2,"i":1,"l":190,"h":3},{"s":"					RB : begin","f":2,"i":1,"l":202,"h":3},{"s":"					RC : begin","f":2,"i":1,"l":214,"h":3},{"s":"All False","f":2,"i":1,"l":177,"h":0}],"br":{"s":"				case(data)","f":2,"l":177,"i":1,"p":80.00}},{"bs":[{"s":"								if(addbus_ram !== 12'bz ||","f":2,"i":1,"l":179,"h":0},{"s":"All False","f":2,"i":1,"l":179,"h":5}],"br":{"s":"								if(addbus_ram !== 12'bz ||","f":2,"l":179,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_proca ||","f":2,"i":1,"l":191,"h":0},{"s":"All False","f":2,"i":1,"l":191,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_proca ||","f":2,"l":191,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_procb ||","f":2,"i":1,"l":203,"h":0},{"s":"All False","f":2,"i":1,"l":203,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_procb ||","f":2,"l":203,"i":1,"p":50.00}},{"bs":[{"s":"								if(addbus_ram !== addbus_procc ||","f":2,"i":1,"l":215,"h":0},{"s":"All False","f":2,"i":1,"l":215,"h":3}],"br":{"s":"								if(addbus_ram !== addbus_procc ||","f":2,"l":215,"i":1,"p":50.00}},{"bs":[{"s":"					RAB  : begin                ","f":2,"i":1,"l":280,"h":1},{"s":"					RBC  : begin                ","f":2,"i":1,"l":292,"h":1},{"s":"					RCA  : begin                ","f":2,"i":1,"l":304,"h":1},{"s":"All False","f":2,"i":1,"l":279,"h":0}],"br":{"s":"				case(data)","f":2,"l":279,"i":1,"p":75.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_procb ||","f":2,"i":1,"l":281,"h":0},{"s":"All False","f":2,"i":1,"l":281,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_procb ||","f":2,"l":281,"i":1,"p":50.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_procc ||","f":2,"i":1,"l":293,"h":0},{"s":"All False","f":2,"i":1,"l":293,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_procc ||","f":2,"l":293,"i":1,"p":50.00}},{"bs":[{"s":"									if(addbus_ram !== addbus_proca ||","f":2,"i":1,"l":305,"h":0},{"s":"All False","f":2,"i":1,"l":305,"h":1}],"br":{"s":"									if(addbus_ram !== addbus_proca ||","f":2,"l":305,"i":1,"p":50.00}},{"bs":[{"s":"			NOREQ    : begin","f":2,"i":1,"l":323,"h":1},{"s":"			REQFA    : begin","f":2,"i":1,"l":329,"h":1},{"s":"			REQFB    : begin","f":2,"i":1,"l":336,"h":1},{"s":"			REQFC    : begin","f":2,"i":1,"l":343,"h":2},{"s":"			SACC     : begin","f":2,"i":1,"l":350,"h":1},{"s":"			ATCAB    : begin","f":2,"i":1,"l":356,"h":1},{"s":"			ATCBC    : begin","f":2,"i":1,"l":363,"h":1},{"s":"			ATCCA    : begin","f":2,"i":1,"l":369,"h":1},{"s":"			REQFBA		: begin                                  ","f":2,"i":1,"l":375,"h":1},{"s":"			REQFCB		: begin                                 ","f":2,"i":1,"l":381,"h":1},{"s":"All False","f":2,"i":1,"l":322,"h":1}],"br":{"s":"			case(bfm_command)","f":2,"l":322,"i":1,"p":100.00}}]}};
processBranchesData(g_data);