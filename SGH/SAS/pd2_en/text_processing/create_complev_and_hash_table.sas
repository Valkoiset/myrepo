
data name_dict_set;
/*here are read dataset of all possible names dictionary*/
length name_dict $40;
input name_dict;
name_dict=upcase(name_dict);
keep name_dict;
cards;
Maciej
Wojciech
Wac³aw
;
run;

data name_set;
length name $40;
input name;
name=upcase(name);
keep name;
cards;
Mietek
Wacek
Alojzy
Lolek
Maciuchna
Wac³aw
Miecio
W³odek
;
run;



%Macro createscheme(schemat, inSet, keyVarName, dictSet, dictKey, cutoff);

	data &schemat(keep=word scheme ambigous);
      length word $ 50 &dictKey $ 50  scheme $ 50;
      set &inSet;

      if _n_ = 1 then do;
         declare hash hashDict(dataset: "&dictSet");
         declare hiter iter('hashDict');
         rc = hashDict.defineKey("&dictKey");
         rc = hashDict.defineData("&dictKey");
         rc = hashDict.defineDone();
      end;

      max=&cutoff;

      am_count = 0;
      ambigous = 'N';
      
      rc = iter.first();
      do while(rc = 0);

         distance = complev(&keyVarName, &dictKey,"iLn");

         if (distance <= max) then do;

               if (distance = max) then do;
                  am_count = am_count + 1;
               end;
               else 
                  am_count = 0;

               max = distance;
               scheme = &dictKey;
         end;
         
         rc = iter.next();

      end;
      
      if (am_count > 0) then 
         ambigous = 'T';

      word = &keyVarName;

   run;

%mend;

%createscheme(schemat, name_set, name, name_dict_set, name_dict, 5);

