<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Thilina Prasad
  Date: 7/6/2018
  Time: 10:08 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Users</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-rc.2/css/materialize.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.css">
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Titillium+Web" rel="stylesheet">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.1.0/css/all.css" integrity="sha384-lKuwvrZot6UHsBSfcMvOkWwlCMgc0TaWr+30HWe3a4ltaBwTZhyTEggF5tJv8tbt" crossorigin="anonymous">
    <link rel="shortcut icon" type="image/png" href="https://cdn2.iconfinder.com/data/icons/seo-flat-6/128/38_Target_Audience-32.png" />
</head>
<body>
<nav>
    <div class="nav-wrapper  blue-grey darken-2">
        <a href="/" class="brand-logo"><img src="https://cdn2.iconfinder.com/data/icons/seo-flat-6/128/38_Target_Audience-64.png"></a>
        <a href="#" data-target="mobile-nav" class="sidenav-trigger"><i class="material-icons">menu</i></a>
        <ul class="right hide-on-med-and-down">
            <% if(session.getAttribute("logged")==null) {%>
            <li ><a href="/register">Register</a></li>
            <% } else{%>
            <li class="active"><a href="/user">View</a></li>
            <li ><a href="/search">Search</a></li>
            <li ><a href="/user/view/<%=session.getAttribute("logged").toString() %>">My Profile</a></li>
            <li><a href="/user/logout">Logout</a></li>
            <%}%>
        </ul>
    </div>
</nav>
<ul class="sidenav" id="mobile-nav">
    <% if(session.getAttribute("logged")==null) {%>
    <li ><a href="/register">Register</a></li>
    <% } else{%>
    <li class="active"><a href="/user">View</a></li>
    <li><a href="/search">Search</a></li>
    <li ><a href="/user/view/<%=session.getAttribute("logged").toString() %>">My Profile</a></li>
    <li><a href="/user/logout">Logout</a></li>
    <%}%>
</ul>
<div class="container">
<h3 align="center" class="font_01">AVAILABLE USERS</h3>
    <div class="row" >
    <nav class="col s6 offset-s3" style="padding: 0;">
        <div class="nav-wrapper blue-grey darken-2">
            <div class="input-field">
                <input id="search" type="search" placeholder="Filter users..." onkeyup="filterTable(this.value)">
                <label class="label-icon" for="search"><i class="material-icons">search</i></label>
                <i class="material-icons">close</i>
            </div>
        </div>
    </nav>
    </div>
<table class="highlight centered" id="userData">
    <thead>
    <tr>
        <th>First name</th>
        <th>Last name</th>
        <th>Email</th>
        <th>Address</th>
        <th>Actions</th>
    </tr>
    </thead>

    <tbody>
    <c:forEach var="user" items="${users}">
        <tr id="user-row-${user.id}">
            <td><c:out value="${user.firstname}"/></td>
            <td><c:out value="${user.lastname}"/></td>
            <td><c:out value="${user.email}"/></td>
            <td><c:out value="${user.address}"/></td>
            <td>
                <a href="/user/view/${user.id}" class="waves-effect waves-light btn"><i class="material-icons right">person_pin</i>View</a>
                <a href="/user/edit/<c:out value="${user.id}"/>" class="waves-effect waves-light btn blue-grey darken-2"><i class="material-icons right">mode_edit</i>Edit</a>
                <a class="waves-effect waves-light btn red darken-2" data-id="${user.id}" onclick="deleteUser(this);"><i class="material-icons right">delete</i>Delete</a>

            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0-rc.2/js/materialize.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-confirm/3.3.0/jquery-confirm.min.js"></script>
<script>
    $(document).ready(function () {
        $(".sidenav").sidenav();
    });

    function deleteUser(user){
        var id = $(user).attr("data-id");
        $.confirm({
            theme: 'modern',
            boxWidth: '500px',
            icon: "far fa-trash-alt",
            type: 'red',
            useBootstrap: false,
            title: 'Delete user',
            content: 'Are you sure you want to delete user ?',
            buttons: {
              yes: {
                    text: 'Yes',
                    btnClass: 'btn-red',
                    keys: ['enter'],
                    action: function(){
                        $.get("user/"+id, function(data, status){
                            if(data=="success"){
                                $("#user-row-"+id).css("display","none");
                                $.alert({
                                    theme: 'modern',
                                    boxWidth: '500px',
                                    useBootstrap: false,
                                    title: 'Success!',
                                    icon:"far fa-check-circle",
                                    type: 'green',
                                    content: 'User Deleted successfully!',
                                });
                            }else{
                                $.alert({
                                    theme: 'modern',
                                    boxWidth: '500px',
                                    useBootstrap: false,
                                    title: 'Error!',
                                    icon:"fas fa-exclamation-circle",
                                    type: 'red',
                                    content: 'Error happened while deleting!',
                                });
                            }
                        });
                    }
                },
                no: {
                    text: 'No',
                    keys: ['esc'],
                    action: function(){
                    }
                }

            }
        });
    }

    function filterTable(input) {
        var input, filter, table, tr, td, i;
        filter = input.toUpperCase();
        table = document.getElementById("userData");
        tr = table.getElementsByTagName("tr");
        for (i = 0; i < tr.length; i++) {
            td = tr[i].getElementsByTagName("td")[0];
            if (td) {
                if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }

</script>
</body>
</html>
