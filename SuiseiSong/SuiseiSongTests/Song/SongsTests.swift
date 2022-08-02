//
//  GetSongFronJsonTests.swift
//  SuiseiSongTests
//
//  Created by shinkaitomomichi on 2022/07/14.
//

import XCTest

class SongsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // testをPrefixにしない（ファイルを分けた方が綺麗か）
    func setupTestSongs() -> [Song] {
        let songs :[Song] = [
            Song(id: 0, members: "星街すいせい", videoid: "", songtitle: "a", starttime: 0, endtime: 60, artist: "星街すいせい", artisturl: "", collaboration: false, anime: false, rock: false, vocaloid: false, acappella: false, live3d: false),
            Song(id: 1, members: "星街すいせい", videoid: "", songtitle: "a", starttime: 0, endtime: 60, artist: "星街すいせい", artisturl: "", collaboration: false, anime: false, rock: false, vocaloid: false, acappella: false, live3d: false),
            Song(id: 2, members: "星街すいせい", videoid: "", songtitle: "a", starttime: 0, endtime: 60, artist: "星街すいせい", artisturl: "", collaboration: false, anime: false, rock: false, vocaloid: false, acappella: false, live3d: false),
            Song(id: 3, members: "星街すいせい", videoid: "", songtitle: "a", starttime: 0, endtime: 60, artist: "星街すいせい", artisturl: "", collaboration: false, anime: false, rock: false, vocaloid: false, acappella: false, live3d: false),
            Song(id: 4, members: "星街すいせい", videoid: "", songtitle: "a", starttime: 0, endtime: 60, artist: "星街すいせい", artisturl: "", collaboration: false, anime: false, rock: false, vocaloid: false, acappella: false, live3d: false),
        ]
        return songs
    }
    
    // シングルトンのテストであるため、テスト用のインスタンスを作れるようにしておきたい
    func testExample() throws {
        let _ = setupTestSongs()
        XCTAssertTrue(true)
    }

}
