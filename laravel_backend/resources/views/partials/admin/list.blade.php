<table class="table table-sm table-striped table-bordered">
    <thead>
    <tr>
        <th>Name</th>
        <th>Email</th>
        <th>Created By</th>
        <th>Created at</th>
    </tr>
    </thead>
    <tbody>
    @foreach($users as $user)
        <tr>
            <td>{{@$user->name}}</td>
            <td>{{@$user->email}}</td>
            <td>{{@$user->created_by}}</td>
            <td>{{@$user->created_at->format('Y-m-d')}}</td>
        </tr>
    @endforeach
    </tbody>
</table>
