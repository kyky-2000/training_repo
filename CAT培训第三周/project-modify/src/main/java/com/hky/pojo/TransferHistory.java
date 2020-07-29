package com.hky.pojo;

public class TransferHistory {
    private String date;
    private String team;

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getTeam() {
        return team;
    }

    public void setTeam(String team) {
        this.team = team;
    }

    @Override
    public String toString() {
        return "TransferHistory{" +
                "date='" + date + '\'' +
                ", team='" + team + '\'' +
                '}';
    }
}
