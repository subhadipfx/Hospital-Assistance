<table class="table table-bordered table-info">
    <thead>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Address</th>
        <th>Added By</th>
        <th>Added at</th>
    </tr>
    </thead>
    <tbody>
    @foreach($users as $user)
        <tr>
            <td>
                <a href="{{url("/hospital/bed/dashboard/".$user->details()->id)}}">{{@$user->name}}</a>
            </td>
            <td>{{@$user->email}}</td>
            <td>{{@$user->details()->phone}}</td>
            <td>{{@$user->details()->address}}</td>
            <td>{{@$user->created_by}}</td>
            <td>{{@$user->created_at->format('Y-m-d')}}</td>
        </tr>
    @endforeach
    </tbody>
</table>
