package com.aiddata.estimator.entities;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Top level class for the JSON results that are returned from
 * the CLIFF web service call.  This is not a complete list 
 * of fields returned from the web service, just the ones 
 * we need to get the mentions data and the status of the 
 * web service call.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Parser {
    private String status;
    private int rowNumber;
    
    public Parser()
    {}


    
    /**
     * @return the status
     */
    public String getStatus() {
        return status;
    }

    /**
     * @param status the status to set
     */
    public void setStatus(String status) {
        this.status = status;
    }
    
    
    public void setRowNumber(int rowNumber){
        this.rowNumber = rowNumber;
    }
    
    public int getRowNumber(){
        return rowNumber;
    }
}
