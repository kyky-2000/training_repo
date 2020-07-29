package com.hky.pojo;

import java.util.List;

public class PageBean<T> {
    private int currentPage;
    private int startIndex;
    private int totalPage;
    private int totalCount;
    private int size;
    private String condition;
    private String status;
    private List<T> dataList;

    public int getCurrentPage() {
        return currentPage;
    }

    public void setCurrentPage(int currentPage) {
        this.currentPage = currentPage;
    }

    public int getStartIndex() {
        return startIndex;
    }

    public void setStartIndex(int startIndex) {
        this.startIndex = startIndex;
    }

    public int getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(int totalPage) {
        this.totalPage = totalPage;
    }

    public int getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(int totalCount) {
        this.totalCount = totalCount;
    }

    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }

    public String getCondition() {
        return condition;
    }

    public void setCondition(String condition) {
        this.condition = condition;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<T> getDataList() {
        return dataList;
    }

    public void setDataList(List<T> dataList) {
        this.dataList = dataList;
    }

    @Override
    public String toString() {
        return "PageBean{" +
                "currentPage=" + currentPage +
                ", startIndex=" + startIndex +
                ", totalPage=" + totalPage +
                ", totalCount=" + totalCount +
                ", size=" + size +
                ", condition='" + condition + '\'' +
                ", status='" + status + '\'' +
                ", dataList=" + dataList +
                '}';
    }
}
