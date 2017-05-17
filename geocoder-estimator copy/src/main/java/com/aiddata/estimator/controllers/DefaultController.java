package com.aiddata.estimator.controllers;

import java.net.HttpURLConnection;
import java.util.Arrays;
import java.util.List;


import java.io.BufferedReader;
import java.io.PrintStream;
import java.net.URL;
import java.net.URLConnection;

import com.opencsv.CSVReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Controller
public class DefaultController {
    
    final String HADALY_URL= "http://hadaly.itpir.wm.edu:8000/api/autocoder?input=";
    final int THREADS_TO_RUN = 9;
    private int lineCount;
    List<String> columnNames = new ArrayList<>();
    MultipartFile inputFile;
    
    @RequestMapping(value="/", method= RequestMethod.GET)
    public String index(ModelMap map) {
        return "index";
    }
    
    @RequestMapping(value = "/parseFile", method = RequestMethod.POST, produces = {"application/json"})
    public @ResponseBody HashMap<String, Object> parseFile(MultipartHttpServletRequest request,
            HttpServletResponse response) throws IOException {
    
        this.inputFile = request.getFile("fileInput");

        HashMap<String, Object> map = new HashMap<>();
        
        try {
            if (this.inputFile != null && !this.inputFile.isEmpty()){
                InputStream inputStream = this.inputFile.getInputStream();
                CSVReader csvReader = new CSVReader(new InputStreamReader(inputStream));
                boolean firstLineProcessed = false;
                
                String[] nextLine;
                for (this.lineCount = 1; (nextLine = csvReader.readNext()) != null; lineCount++)
                {
                    // The first line should just display the headers for what the data
                    // in the file represents, so we do not need to process it
                                              
                    if (!firstLineProcessed)
                    {
                       
                           for (int i = 0; i < nextLine.length; i++)
                        {
                            columnNames.add(nextLine[i]);
                            map.put(Integer.toString(i), nextLine[i]);
                        }
                        firstLineProcessed = true;
                        continue;
                    }
                }
            }
        }
        catch (Exception ex)
        {
            map.put("errorMessage", "Error occurred reading file: " + ex.getMessage());
            return map;
        }
        return map;
    }
        
    
    @RequestMapping(value = "/translateColumns", method = RequestMethod.POST, produces = {"application/json"})
    public @ResponseBody MultipartFile translateColumns(MultipartHttpServletRequest request,
            HttpServletResponse response) throws IOException {
   

        String[] selectedFields = request.getParameterValues("translateInput");
        //MultipartFile translatedFile = createCSV(selectedFields);
        
        return this.inputFile;
      //  return translatedFile;
    }
    
      @RequestMapping(value = "/activitySend", method = RequestMethod.POST, produces = {"application/json"})
    public @ResponseBody HashMap<String, Object> activitySend(MultipartHttpServletRequest request,
            HttpServletResponse response) throws IOException {
            String[] query = request.getParameterValues("activity_Text");
             HashMap<String, Object> map = new HashMap<>();

            String query_send = query[0].toString();
            query_send=query_send.replace(" ", "%");
            
            String hadaly = "http://hadaly.itpir.wm.edu:8000/api/autocoder?input=";
            
           hadaly = hadaly.concat(query_send);
            URL url = new URL(hadaly);

            
             HttpURLConnection uc = (HttpURLConnection) url.openConnection();
             uc.setRequestMethod("GET");
                uc.setDoInput(true);

             InputStream is = uc.getInputStream();
            StringBuffer sb = new StringBuffer();
          

          //  ps.print(hadaly);    

           // BufferedReader br = new BufferedReader(new InputStreamReader(urlc.getInputStream()));
            //String l = null;
            StringBuilder a = new StringBuilder();
            int l;
            
            while ((l = is.read()) != -1) {
                     a.append((char) l);
                    //System.out.println(l);
                    
            }
            System.out.println(a);
            uc.disconnect();

            //rbr.close();
            String b = a.toString();
            map.put("code", b);

           return map;
        //MultipartFile translatedFile = createCSV(selectedFields);
        
      //  return translatedFile;
    }
    
    /*
    * Creates a new CSV File with the former selected columns translated, and 
    * the rest of the values remaining the same.
    */
    /*
    public MultipartFile createCSV(String[] selectedFields)
    { 
       List<String> list = Arrays.asList(selectedFields);
       List<Integer> tobeAdded = new ArrayList<Integer>();
       
    
       try {
            if (this.inputFile != null && !this.inputFile.isEmpty()){
                InputStream inputStream = this.inputFile.getInputStream();
                CSVReader csvReader = new CSVReader(new InputStreamReader(inputStream));
                
                String[] nextLine = csvReader.readNext();
                
                
                //gets the column numbers of each selected value and adds it to
                // the processing list
                for (int i = 0; i < nextLine.length; i++)
                {
                    if (list.contains(nextLine[i]))
                    {
                        tobeAdded.add(i);
                    }
                }
                
                
                for (this.lineCount = 1; (nextLine = csvReader.readNext()) != null; lineCount++)
                {
                    // The first line should just display the headers for what the data
                    // in the file represents, so we do not need to process it
                                       
                    for (int i = 0; i < nextLine.length; i++)
                       {
                           if(tobeAdded.contains(i))
                           {
                             String translated = Translate.execute(nextLine[i], Language.AUTO_DETECT, Language.ENGLISH);
                             nextLine[i] = translated;
                            
                               // add translated value to the csv
                           }
                           else
                           {
                               continue;
                               //add non translated value to the csv
                           }
                       }
                    }
                }
            }
        catch (Exception ex)
        {
            return out;
        }
        return out;
    }
*/
}