import pandas as pd


input_file_name = 'columbia.csv'
df_whole_data = pd.read_csv(input_file_name, encoding='utf-8', sep=',')
df_whole_data = df_whole_data.fillna('0')

crosswalk = pd.read_csv('activity.csv', encoding='utf-8', sep=',')
#crosswalk = crosswalk.fillna(0)
cross_dict = crosswalk.set_index('Activity_code').T.to_dict('list')




def f1(seq):
   # not order preserving
   set = {}
   map(set.__setitem__, seq, [])
   return set.keys()


for i in df_whole_data.index:
    real_list = []  
    new_text = []
    input_text = df_whole_data['AidData Activity Code(s)'][i] 
    new_text = str(input_text).split('|')      
   
    print(new_text)
    print(len(new_text))
    for j in range (0,len(new_text)):
        purpose = str(new_text[j])
        cross_list = cross_dict[purpose]
        for h in cross_list:
            if (str(h) != 'nan' and str(h) != '0'):
                real_list.append(h)  
            #new_list = f1(real_list)
            my_str = str(real_list[0])
            for k in range(0, len(real_list)):    
                my_str = my_str + ' |' + str(real_list[k])            
                #print(my_str)
                df_whole_data.set_value(i, 'SDG Goals Duplicates', my_str)
            
            new_list = f1(real_list)
            my_str = str(new_list[0])
            for k in range(1, len(new_list)):    
                my_str = my_str + ' |' + str(new_list[k])            
                #print(my_str)
                df_whole_data.set_value(i, 'SDG Goals Unique', my_str)            


df_whole_data.to_csv('columbia_crosswalk2.csv', sep=',', index=False, encoding='utf-8')




        
        
        
        
        
                               