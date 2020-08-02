package com.hky.pojo;

import java.util.Date;
import java.util.List;
import java.util.Map;

public class User {
    private Integer id;

    private String name;

    private Integer age;

    private String gender;

    private String mail;

    private String password;

    private String lastTeam;

    private String identity;

    private Date joinDate;

    private String profile;

    private String head;

    private String status;

    private List<TransferHistory> historyList;

    private List<String> pictures;

    private List<Letter> letters;

    //前端传过来的图形验证码
    private String checkCode;

    //前端传过来的邮件验证码
    private String emailCode;

    public User(){

    }

    public User(Integer id, String name, Integer age, String gender, String mail, String password, String lastTeam, String identity, Date joindate, String profile, String head, String status) {
        this.id = id;
        this.name = name;
        this.age = age;
        this.gender = gender;
        this.mail = mail;
        this.password = password;
        this.lastTeam = lastTeam;
        this.identity = identity;
        this.joinDate = joindate;
        this.profile = profile;
        this.head = head;
        this.status = status;
    }

    public List<Letter> getLetters() {
        return letters;
    }

    public void setLetters(List<Letter> letters) {
        this.letters = letters;
    }

    public List<TransferHistory> getHistoryList() {
        return historyList;
    }

    public void setHistoryList(List<TransferHistory> historyList) {
        this.historyList = historyList;
    }

    public List<String> getPictures() {
        return pictures;
    }

    public void setPictures(List<String> pictures) {
        this.pictures = pictures;
    }

    public String getEmailCode() {
        return emailCode;
    }

    public void setEmailCode(String emailCode) {
        this.emailCode = emailCode;
    }

    public String getCheckCode() {
        return checkCode;
    }

    public void setCheckCode(String checkCode) {
        this.checkCode = checkCode;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender == null ? null : gender.trim();
    }

    public String getMail() {
        return mail;
    }

    public void setMail(String mail) {
        this.mail = mail == null ? null : mail.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public String getLastTeam() {
        return lastTeam;
    }

    public void setLastTeam(String lastTeam) {
        this.lastTeam = lastTeam == null ? null : lastTeam.trim();
    }

    public String getIdentity() {
        return identity;
    }

    public void setIdentity(String identity) {
        this.identity = identity == null ? null : identity.trim();
    }

    public Date getJoinDate() {
        return joinDate;
    }

    public void setJoinDate(Date joinDate) {
        this.joinDate = joinDate;
    }

    public String getProfile() {
        return profile;
    }

    public void setProfile(String profile) {
        this.profile = profile == null ? null : profile.trim();
    }

    public String getHead() {
        return head;
    }

    public void setHead(String head) {
        this.head = head == null ? null : head.trim();
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status == null ? null : status.trim();
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", age=" + age +
                ", gender='" + gender + '\'' +
                ", mail='" + mail + '\'' +
                ", password='" + password + '\'' +
                ", lastTeam='" + lastTeam + '\'' +
                ", identity='" + identity + '\'' +
                ", joinDate=" + joinDate +
                ", profile='" + profile + '\'' +
                ", head='" + head + '\'' +
                ", status='" + status + '\'' +
                ", historyList=" + historyList +
                ", pictures=" + pictures +
                ", letters=" + letters +
                '}';
    }
}