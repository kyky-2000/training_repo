package com.hky.pojo;

import java.util.Date;
import java.util.List;

public class TransferInfo {
    private Integer id;

    private Integer userId;

    private String name;

    private String introduce;

    private String photo;

    private String gameCareer1;

    private String gameCareer2;

    private String gameCareer3;

    private Integer salary;

    private String boss;

    private String status;

    private Date deadline;

    private List<String> pictures;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public String getIntroduce() {
        return introduce;
    }

    public void setIntroduce(String introduce) {
        this.introduce = introduce == null ? null : introduce.trim();
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo == null ? null : photo.trim();
    }

    public String getGameCareer1() {
        return gameCareer1;
    }

    public void setGameCareer1(String gameCareer1) {
        this.gameCareer1 = gameCareer1 == null ? null : gameCareer1.trim();
    }

    public String getGameCareer2() {
        return gameCareer2;
    }

    public void setGameCareer2(String gameCareer2) {
        this.gameCareer2 = gameCareer2 == null ? null : gameCareer2.trim();
    }

    public String getGameCareer3() {
        return gameCareer3;
    }

    public void setGameCareer3(String gameCareer3) {
        this.gameCareer3 = gameCareer3 == null ? null : gameCareer3.trim();
    }

    public Integer getSalary() {
        return salary;
    }

    public void setSalary(Integer salary) {
        this.salary = salary;
    }

    public String getBoss() {
        return boss;
    }

    public void setBoss(String boss) {
        this.boss = boss == null ? null : boss.trim();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public List<String> getPictures() {
        return pictures;
    }

    public void setPictures(List<String> pictures) {
        this.pictures = pictures;
    }
}