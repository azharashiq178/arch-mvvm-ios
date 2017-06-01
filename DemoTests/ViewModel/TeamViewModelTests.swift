//
//  TeamViewModelTests.swift
//  Demo
//
//  Created by Huynh Quang Tien on 6/1/17.
//  Copyright © 2017 Asian Tech Co., Ltd. All rights reserved.
//

import XCTest
import MVVM
import RealmSwift
import ObjectMapper
import RealmS
@testable import Demo

class TeamViewModelTests: XCTestCase {
    func testReturnFromTeamViewModel() {
        let ex = expectation(description: "testReturnFromTeamViewModel")
        let teamId = 1
        let vm = TeamViewModel(teamId: teamId)
        vm.getTeamDetail { (result) in
            switch result {
            case .success:
                let team = RealmS().object(ofType: Team.self, forPrimaryKey: teamId)
                guard let teamObj = team, let vmDetail = vm.teamDetailViewModel else { break }
                XCTAssertEqual(vmDetail.name, teamObj.name)
                XCTAssertEqual(vmDetail.slug, teamObj.slug)
                XCTAssertEqual(vmDetail.desc, teamObj.desc)
                let memberCount = "\(teamObj.memberCount) members"
                let repoCount = "[\(teamObj.repoCount)]"
                XCTAssertEqual(vmDetail.memberCount, memberCount)
                XCTAssertEqual(vmDetail.repoCount, repoCount)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            ex.fulfill()
        }

        waitForExpectations(timeout: Timeout.forRequest)
    }
}
